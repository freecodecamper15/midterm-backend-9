class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :category_id
  end
end
