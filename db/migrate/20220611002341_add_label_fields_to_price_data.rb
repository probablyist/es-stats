class AddLabelFieldsToPriceData < ActiveRecord::Migration[7.0]
  def change
    add_column :price_data, :trading_day, :date
    add_column :price_data, :trading_session, :string
    add_column :price_data, :period, :integer
    add_column :price_data, :onh, :float
    add_column :price_data, :onl, :float
    add_column :price_data, :fhh, :float
    add_column :price_data, :fhl, :float
  end
end
