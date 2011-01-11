class CommentsController < ApplicationController
  before_filter do
    @presentation = Presentation.find params[:presentation_id]
  end

  def new
    respond_with @comment
  end

  def create
     @comment = @presentation.comments.new params[:comment]
     @comment.user = current_user
     @comment.save
     redirect_to(presentation_path)
  end

  def destroy
    raise CanCan::AccessDenied if current_user.nil? || current_user != @comment.user
    @comment = @presentation.comments.find params[:id]
    @comment.destroy
    respond_with @presentation
  end
end
