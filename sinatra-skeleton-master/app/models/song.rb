class Song < ActiveRecord::Base

  belongs_to :user

  validates :title, presence: true, length: { maximum: 40 }
  validates :url, presence: true
  validates :author, presence: true, length: { maximum: 40 }
end