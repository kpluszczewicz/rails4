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
     redirect_to presentation_path(@presentation)
  end

  def destroy
    @comment = Comment.find params[:id]
    @presentation = Presentation.find(params[:presentation_id])
    if current_user.nil?
      raise CanCan::AccessDenied
    else
      if current_user != @presentation.owner
        raise CanCan::AccessDenied if @comment.user != current_user
      end
    end
    @comment = @presentation.comments.find params[:id]
    @comment.destroy
    redirect_to presentation_path @presentation
  end
end
