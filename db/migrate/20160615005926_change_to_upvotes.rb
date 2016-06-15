class ChangeToUpvotes < ActiveRecord::Migration
  def change
    rename_table :upvote, :upvotes
  end
end
