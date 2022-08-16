class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user


  has_rich_text :body

  enum status: ['publish', 'draft']

  scope :published, -> { where('status = ?', Article.statuses[:publish])}

  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments

  has_many :likes, dependent: :destroy
  accepts_nested_attributes_for :likes
end
