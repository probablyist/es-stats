class CreateStats < ActiveRecord::Migration[7.0]
  def change
    create_table :stats do |t|
      t.date :trading_day, null: false
      t.string :breach_onh
      t.string :breach_onl
      t.string :breach_fhh
      t.string :breach_fhl
      t.string :breach_ah
      t.string :breach_al

      t.timestamps
    end
    add_index :stats, :trading_day, unique: true
  end
end
