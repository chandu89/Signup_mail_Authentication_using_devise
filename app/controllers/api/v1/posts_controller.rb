class Api::V1::PostsController < Api::ApiController
	respond_to :json
  before_action :authenticate
 
  def index
    @posts = @user.posts.all
    @response = {:user=> @user, :posts=>@posts}
    respond_with @response
  end
end
