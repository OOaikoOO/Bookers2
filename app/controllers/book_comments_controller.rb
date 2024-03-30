class BookCommentsController < ApplicationController
  
  def create
    @book = Book.find(params[:book_id])
    @user = @book.user
    @comment = current_user.book_comments.new(book_comment_params)
    if @comment.save
      redirect_to book_path(@book)
    else
      render 'books/show'
    end
  end
  
  def destroy
    @comment = BookComment.find(params[:id])
    @book = @comment.book
    @comment.destroy
    redirect_to book_path(@book)
  end

  private
  
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
