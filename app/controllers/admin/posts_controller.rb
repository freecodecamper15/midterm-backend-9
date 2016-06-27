class Admin::PostsController < ApplicationController

  before_action :authenticate

  layout "admin"

  def index
    @posts = Post.all
  end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == 'username' && password == 'password'
      end
    end
end
