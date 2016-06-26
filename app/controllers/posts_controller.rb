class PostsController < ApplicationController
  before_action :find_post, :only => [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :only => [:new, :create]

  def index
    @posts = Post.page(params[:page]).per(5).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user == current_user
    @post.save

    redirect_to posts_path
    flash[:notice] = 'The post has been saved:)'
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy

      flash[:notice] = 'Congrats, your post has been removed!'
    else
      flash[:alert] = 'Nothing has been destroyed:('
    end

    redirect_to posts_path
  end


  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id)
  end


end
