class AddMainCourseToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :main_course, :boolean, default: false
  end
end
