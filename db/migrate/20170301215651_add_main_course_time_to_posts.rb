class AddMainCourseTimeToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :main_course_added_at, :datetime
  end
end
