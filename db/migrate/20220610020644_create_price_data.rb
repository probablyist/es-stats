class CreatePriceData < ActiveRecord::Migration[7.0]
  def change
    create_table :price_data do |t|
      t.datetime :date_time, null: false
      t.float :open, null: false
      t.float :high, null: false
      t.float :low, null: false
      t.float :close, null: false

      t.timestamps
    end
    add_index :price_data, :date_time, unique: true
  end
end
