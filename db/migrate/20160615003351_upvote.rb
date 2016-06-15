class Upvote < ActiveRecord::Migration
  def change
    create_table(:upvote) do |t|
      t.boolean :like
      t.references :user
      t.references :message
    end
  end
end
