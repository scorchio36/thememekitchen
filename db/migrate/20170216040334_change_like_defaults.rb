class ChangeLikeDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:posts, :likes, nil)
    change_column_default(:posts, :dislikes, nil)
  end

end
