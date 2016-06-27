class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.new(comment_params)

    @comment.user = current_user
    @comment.save

    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find_by_id(params[:id])
    if @comment.user == current_user
      @comment.destroy

      flash[:notice] = 'You\'ve deleted the comment.'
    else
      flash[:alert] = 'You don\'t have the authority to delete any comment...'
    end

    redirect_to :back
  end


  protected

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end

