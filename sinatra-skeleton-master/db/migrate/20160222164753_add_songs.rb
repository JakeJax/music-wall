class AddSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.references (:user)
      t.string :title
      t.string :author
      t.string :url

      t.timestamps null: false
    end
  end
end