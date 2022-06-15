class Stats < ApplicationRecord
  has_many :price_data

  def self.period_hash
    period_hash = {
      A: 0,
      B: 0,
      C: 0,
      D: 0,
      E: 0,
      F: 0,
      G: 0,
      H: 0,
      I: 0,
      J: 0,
      K: 0,
      L: 0,
      M: 0,
      N: 0,
      O: 0
    }
  end

  @total_days = Stats.all.size
  def self.all_stats_raw
    raw = {
      on: count_breach_on,
      fh: count_breach_fh,
      a: count_breach_a
    }
  end



  def self.count_breach_fh
      high = period_hash.except(:A, :B)
      low = period_hash.except(:A, :B)
      either = period_hash.except(:A, :B)
      x = {
        both: 0,
        none: 0
      }

    Stats.all.each do |s|
      if s.breach_fhh.present? && s.breach_fhl.present?
        x[:both] += 1
        if s.breach_fhh < s.breach_fhl
          either[s.breach_fhh.to_sym] += 1
        else
          either[s.breach_fhl.to_sym] += 1
        end
      elsif s.breach_fhh.present?
        high[s.breach_fhh.to_sym] += 1
        either[s.breach_fhh.to_sym] += 1
      elsif s.breach_fhl.present?
        low[s.breach_fhl.to_sym] += 1
        either[s.breach_fhl.to_sym] += 1
      else
        x[:none] += 1
      end
    end

    breach_on = {
      high_acc: hash_to_percentage(accumulate_periods(high)),
      high: hash_to_percentage(high),
      low_acc: hash_to_percentage(accumulate_periods(low)),
      low: hash_to_percentage(low),
      either: hash_to_percentage(either),
      x: hash_to_percentage(x)
    }
  end

  def self.count_breach_on
    high = period_hash
    low = period_hash
    either = period_hash
    x = {
      both: 0,
      none: 0
    }

  Stats.all.each do |s|
    sh = s.breach_onh
    sl = s.breach_onl
    if sh.present? && sl.present?
        x[:both] += 1
      high[sh.to_sym] += 1
      low[sl.to_sym] += 1
      if sh < sl
        either[sh.to_sym] += 1
      else
        either[sl.to_sym] += 1
      end
    elsif sh.present?
      high[sh.to_sym] += 1
      either[sh.to_sym] += 1
    elsif sl.present?
      low[sl.to_sym] += 1
      either[sl.to_sym] += 1
    else
      x[:none] += 1
    end
  end




  breach_on = {
    high_acc: hash_to_percentage(accumulate_periods(high)),
    high: hash_to_percentage(high),
    low_acc: hash_to_percentage(accumulate_periods(low)),
    low: hash_to_percentage(low),
    either: hash_to_percentage(either),
    x: hash_to_percentage(x)
  }
end

def self.count_breach_a
  either = 0
  both = 0
  high = []
  low = []

  Stats.all.each do |s|
    if s.breach_ah.present? && s.breach_al.present?
      either += 1
      both += 1
      high << s.breach_ah.to_f
      low << s.breach_al.to_f
    elsif s.breach_ah.present?
      either += 1
      high << s.breach_ah.to_f
    elsif s.breach_al.present?
      either += 1
      low << s.breach_al.to_f
    end

  end

  high = { count: percent_of_total(high.size), avg: mean_ticks(high) }
  low = { count: percent_of_total(low.size), avg: mean_ticks(low) }

  breach_a = {
    either: percent_of_total(either),
    both: percent_of_total(both),
    high: high,
    low: low
  }
end


##### Helpers #####

def self.hash_to_percentage(hash)
  p hash
  hash.each do |k, v|
    hash[k] = percent_of_total(v) #unless hash[k].blank?
  end
  hash
end

def self.percent_of_total(num)
  ActiveSupport::NumberHelper.number_to_percentage(num.to_f / @total_days * 100, precision: 2)
end

def self.accumulate_periods(hash)
  sum = 0
  hash.transform_values { |v| sum += v }
end

def self.mean_ticks(array)
  mean = array.sum(0.0) / array.size
  mean = (mean * 4).round / 4.0
end


  ##### UPDATE FIELDS #####
  def self.update_breaches
    add_breach_onh
    add_breach_onl
    add_breach_fhh
    add_breach_fhl
    add_breach_a_high
    add_breach_a_low
  end

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
      a = PriceData.a_period.where(trading_day: s.trading_day).pluck(:high).first
      b = PriceData.b_period.where(trading_day: s.trading_day).pluck(:high).first

      if b > a
        s.update!(breach_ah: b-a)
      end
    end
  end

  # Adds B period breach of A period low
  def self.add_breach_a_low
    Stats.all.each do |s|
      a = PriceData.a_period.where(trading_day: s.trading_day).pluck(:low).first
      b = PriceData.b_period.where(trading_day: s.trading_day).pluck(:low).first

      if b < a
        s.update!(breach_al: a-b)
      end
    end
  end
end
