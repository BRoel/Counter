class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :meal
      t.string :food_type
      t.date :date
      t.decimal :calories, precision: 10
      t.integer :user_id
    end
  end
end
