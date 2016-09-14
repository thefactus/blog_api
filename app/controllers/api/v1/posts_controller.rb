module Api
  module V1
    class PostsController < ApiController
      skip_before_action :auth_with_token!
      before_action :add_allow_credentials_headers, only: [:index, :show, :create]

      def index
        posts = Post.all
        render json: posts
      end

      def show
        post = find_post
        render json: post
      end

      def create
        post = current_user.posts.new(post_params)

        if post.save
          render json: post, status: :created, location: [:api, post]
        else
          render json: { errors: post.errors }, status: :unprocessable_entity
        end
      end

      def update
        post = find_post
        if post.update(post_params)
          render json: post, status: :no_content
        else
          render json: { errors: post.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        post = find_post
        post.destroy
        head :no_content
      end

      private

      def find_post
        Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :subtitle, :body, :user)
      end

      def add_allow_credentials_headers
        response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
        response.headers['Access-Control-Allow-Credentials'] = 'true'
      end
    end
  end
end
