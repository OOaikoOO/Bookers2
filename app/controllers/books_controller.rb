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
    @book_comment = BookComment.new
    @book_detail = Book.find(params[:id])
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.read_counts.create(book_id: @book_detail.id)
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).
      sort_by { |book|
        -book.favorites.where(created_at: from...to).count
      }
    @book = Book.new
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
