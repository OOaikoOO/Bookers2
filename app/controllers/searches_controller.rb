class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content, @method)
      @users = User.search_for(@content, @method)
      @users ||= [] 
    else
      @books = Book.search_for(@content, @method)
      @books ||= []
    end
  end
end
