json.extract! post, :id, :title, :subtitle, :body, :created_at, :updated_at
json.url post_url(post, format: :json)