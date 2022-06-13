class Stats < ApplicationRecord

  # Adds All unique trading days from PriceData table
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


end
