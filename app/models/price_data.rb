class PriceData < ApplicationRecord

  enum :period, %i[A B C D E F G H I J K L M N O]

  scope :rth_only, -> { where(trading_session: "RTH") }

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

  # Sets overnight trading periods to date of next regular trading session
  def self.set_trading_day
    close_rth = Time.parse("16:30PM").seconds_since_midnight

    PriceData.all.each do |dt|
      time = dt.date_time.seconds_since_midnight
      if time <= close_rth
        dt.update(trading_day: dt.date_time.to_date)
      else
        dt.update(trading_day: (dt.date_time.to_date + 1.day))
      end
    end
  end

  # Sets trading_session to RTH or ON based on open and close of regular trading session
  def self.set_trading_session
    open_rth = Time.parse("8:30AM").seconds_since_midnight
    close_rth = Time.parse("16:30PM").seconds_since_midnight
    PriceData.all.each do |dt|
      time = dt.date_time.seconds_since_midnight
      if time >= open_rth && time <= close_rth
        dt.update(trading_session: "RTH")
      else
        dt.update(trading_session: "ON")
      end
    end
  end

  # Sets period label of RTH 30minute blocks
  def self.set_period
    open_rth = Time.parse("8:30AM").seconds_since_midnight
    thirty = Time.parse("0:30AM").seconds_since_midnight

    periods = periods = {
      "A"=>open_rth,
      "B"=>(open_rth += thirty),
      "C"=>(open_rth += thirty),
      "D"=>(open_rth += thirty),
      "E"=>(open_rth += thirty),
      "F"=>(open_rth += thirty),
      "G"=>(open_rth += thirty),
      "H"=>(open_rth += thirty),
      "I"=>(open_rth += thirty),
      "J"=>(open_rth += thirty),
      "K"=>(open_rth += thirty),
      "L"=>(open_rth += thirty),
      "M"=>(open_rth += thirty),
      "N"=>(open_rth += thirty),
      "O"=>(open_rth += thirty)
    }

    PriceData.rth_only.each do |p|
      periods.each do |k, v|
        if p.date_time.seconds_since_midnight == v
          p.update(period: k)
        end
      end
    end

  end

  def self.set_onh

  end

  def self.set_onl

  end

  def self.set_fhh

  end

  def self.set_fhl

  end
end
