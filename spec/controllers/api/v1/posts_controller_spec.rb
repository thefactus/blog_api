require 'rails_helper'

describe Api::V1::PostsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:new_post) { FactoryGirl.create(:post, user: user) }

  before(:each) { request.headers['Accept'] = 'application/vnd.blog_api.v1' }

  describe 'GET #index' do
    before(:each) do
      new_post
      get :index, format: :json
    end

    it 'returns all posts' do
      expect(json_response).not_to be_empty
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      get :show, params: { id: new_post.id }, format: :json
    end

    it 'returns the information about a post' do
      expect(json_response[:title]).to eq(new_post.title)
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        sign_in_user user
        @post_attributes = FactoryGirl.attributes_for(:post)
        post :create, params: { post: @post_attributes }, format: :json
      end

      it 'renders the json representaion for the post just created' do
        expect(json_response).to include(@post_attributes)
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        sign_in_user user
        @invalid_post_attributes = { title: nil, subtitle: nil, body: nil }
        post :create, params: { post: @invalid_post_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors when the post could not be created' do
        expect(json_response[:errors][:title]).to include("can't be blank")
        expect(json_response[:errors][:subtitle]).to include("can't be blank")
        expect(json_response[:errors][:body]).to include("can't be blank")
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when post is successfully updated' do
      before(:each) do
        sign_in_user user
        patch :update,
              params: { id: new_post.id, post: { title: 'New title' } },
              format: :json
      end

      it 'renders the json representation for the updated post' do
        expect(json_response[:title]).to eq('New title')
      end

      it { should respond_with 204 }
    end

    context 'when post is not updated' do
      before(:each) do
        patch :update,
              params: { id: new_post.id, post: { title: '' } },
              format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors when the post could not be updated' do
        expect(json_response[:errors][:title]).to include("can't be blank")
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      sign_in_user user
      delete :destroy, params: { id: new_post.id }, format: :json
    end

    it { should respond_with 204 }
  end
end
