class Likes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references (:user)
      t.references (:song)

      t.timestamps null: false
    end
  end
end
