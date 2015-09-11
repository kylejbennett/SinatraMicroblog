class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.string :post_title
  		t.string :post_content, limit: 150
  		t.timestamp :post_time
  		t.integer :userid
  	end
  end
end
