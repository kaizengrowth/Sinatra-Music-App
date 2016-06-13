class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :author
      t.string :url
      t.date :created_at
      t.date :updated_at
    end
  end
end
