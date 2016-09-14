class Post < ApplicationRecord
  validates_presence_of :title, :subtitle, :body

  belongs_to :user, optional: true
end
