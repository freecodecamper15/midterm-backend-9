class PostsController < ApplicationController
  before_action :find_post, :only => [:show, :edit, :update, :destroy, :dashboard]
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    prepare_variable_for_index_template
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to posts_path
      flash[:notice] = 'The post has been saved:)'
    end
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

  # get /events/latest
  def latest
    @posts = Post.order('id DESC').limit(3)
  end

  def bulk_update
    ids = Array( params[:ids] )
    posts = ids.map{ |i| Post.find_by_id(i) }.compact

    if params[:commit] == 'Delete'
      posts.each { |p| p.destroy }
    elsif params[:commit] == 'Publish'
      posts.each { |p| p.update( :status => 'published') }
    end

    redirect_to :back
  end

  def dashboard

  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :status)
  end

  def prepare_variable_for_index_template
    if params[:keyword]
      @posts = Post.where( [ "title like ?", "%#{params[:keyword]}%" ] )
    else
      @posts = Post.all
    end

    if params[:order]
      sort_by = (params[:order] == 'title') ? 'title' : 'id'
      @posts = @posts.order(sort_by)
    end

    @posts = @posts.page(params[:page]).per(5)
    #.order('created_at DESC')

  end
end
