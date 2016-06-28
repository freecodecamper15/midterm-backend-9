class CommentsController < ApplicationController
  before_action :authenticate_user! # check if the user has logged in
  before_action :set_post

  def create
    @comment = @post.comments.new(comment_params) # @comment.post_id == @post.id

    @comment.user = current_user
    # @comment belongs to current_user
    # @comment.user_id == current_user.id
    if @comment.save
      # @post.number_of_comments += 1
      # @post.save
    end

    redirect_to post_path(@post)
  end

  def edit
    @comment = @post.comments.find_by_id(params[:id])
    if @comment.user != current_user
      flash[:alert] = 'yo bro you don\'t have the authority to edit this comment'
    end
  end

  def update
    @comment = @post.comments.find_by_id(params[:id])
    if @comment.user == current_user
      @comment.update(comment_params)
      flash[:notice] = 'Your comment update has been saved:)'
    end
    redirect_to post_path(@post)
  end


  def destroy
    @comment = @post.comments.find_by_id(params[:id])
    if @comment.user == current_user # user can only destroy his/her own comments
      # check if the author of the comment is equal to current_user
      if @comment.destroy
        # number of comments -= 1
      end

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

