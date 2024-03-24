class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @user = current_user 
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'
  end

  private

  def book_params
    params.require(:book).permit(:title, :body).merge(user_id: current_user.id)
  end
  
  def is_matching_login_user
    begin
      book = Book.find(params[:id])
      unless book.user_id == current_user.id
        redirect_to '/books'
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to '/books', alert: "Book not found"
    end
  end
end
