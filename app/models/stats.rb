class Stats < ApplicationRecord
has_many :price_data
  # Adds All unique trading days from PriceData table

  def self.update_breaches
    add_breach_onh
    add_breach_onl
    add_breach_fhh
    add_breach_fhl
    add_breach_a_high
    add_breach_a_low
  end

  def self.add_trading_days_to_table
    PriceData.all.distinct.pluck(:trading_day).each do |d|
      Stats.find_or_create_by(trading_day: d)
    end
  end

  # Adds first period breach of Overnight High for each trading day
  def self.add_breach_onh
    Stats.all.each do |s|
      PriceData.rth_only.where(trading_day: s.trading_day).each do |pd|
        if pd.high > pd.onh
          if s.breach_onh.nil? || s.breach_onh > pd.period
            s.update(breach_onh: pd.period)
          end
        end
      end
    end
  end

  # Adds first period breach of Overnight Low for each trading day
  def self.add_breach_onl
    Stats.all.each do |s|
      PriceData.rth_only.where(trading_day: s.trading_day).each do |pd|
        if pd.low < pd.onl
          if s.breach_onl.nil? || s.breach_onl > pd.period
            s.update(breach_onl: pd.period)
          end
        end
      end
    end
  end

  # Adds first period breach of First Hour High for each trading day
  def self.add_breach_fhh
    Stats.all.each do |s|
      PriceData.rth_only.where(trading_day: s.trading_day).each do |pd|
        if pd.high > pd.fhh
          if s.breach_fhh.nil? || s.breach_fhh > pd.period
            s.update!(breach_fhh: pd.period)
          end
        end
      end
    end
  end

  # Adds first period breach of First Hour Low for each trading day
  def self.add_breach_fhl
    Stats.all.each do |s|
      PriceData.rth_only.where(trading_day: s.trading_day).each do |pd|
        if pd.low < pd.fhl
          if s.breach_fhl.nil? || s.breach_fhl > pd.period
            s.update!(breach_fhl: pd.period)
          end
        end
      end
    end
  end

  # Adds B period breach of A period high
  def self.add_breach_a_high
    Stats.all.each do |s|
      a = PriceData.a_period.where(trading_day: s.trading_day).pluck(:high)
      b = PriceData.b_period.where(trading_day: s.trading_day).pluck(:high)

      if b[0] > a[0]
        s.update!(breach_ah: "B")
      end
    end
  end

  # Adds B period breach of A period low
  def self.add_breach_a_low
    Stats.all.each do |s|
      a = PriceData.a_period.where(trading_day: s.trading_day).pluck(:low)
      b = PriceData.b_period.where(trading_day: s.trading_day).pluck(:low)

      if b[0] < a[0]
        s.update!(breach_al: "B")
      end
    end
  end
end
