class Post < ApplicationRecord
  has_many :comments
  validates :name, presence: true, length: { minimum: 5}
  validates :body, presence: true, length: { minimum: 10}
end
