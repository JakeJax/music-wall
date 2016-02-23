class Song < ActiveRecord::Base

  belongs_to :user
  has_many :likes

  validates :title, presence: true, length: { maximum: 40 }
  validates :url, presence: true
  validates :author, presence: true, length: { maximum: 40 }

  def music_user
    userid = self.user_id
    if userid.nil?
      return "no one"
    else
      username = User.find(userid)
      username.name
    end
  end

end