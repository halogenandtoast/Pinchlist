class CreateDiscussionCategories < ActiveRecord::Migration
  def change
    create_table :discussion_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
