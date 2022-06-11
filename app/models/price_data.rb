class PriceData < ApplicationRecord
  def self.load_csv_to_db
    url = URI(ENV["es_data_sheet"])
    body = url.read

    CSV.parse(body, col_sep: ",", headers: true) do |row|
      PriceData.create({
        date_time: row["Date Time"].to_datetime,
        open: row["Open"].to_f,
        high: row["High"].to_f,
        low: row["Low"].to_f,
        close: row["Close"].to_f
      })
    end
  end
end
