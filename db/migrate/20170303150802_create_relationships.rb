class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, index: true
      t.integer :followed_id, index: true

      t.timestamps
    end

    #this line of code makes sure that the relationship of following and being followed is unique between two users. Two users
    #should not be able to follow each other more than once
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
