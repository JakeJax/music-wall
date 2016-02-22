class Song < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 40 }
  validates :url, presence: true
  validates :author, presence: true, length: { maximum: 40 }
end