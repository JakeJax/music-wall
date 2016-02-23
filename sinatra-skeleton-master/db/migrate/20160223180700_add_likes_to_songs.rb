class AddLikesToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :upvotes, :integer
  end
end
