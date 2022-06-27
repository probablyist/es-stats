class Stats < ApplicationRecord
  extend StatsHash
  extend FhhlHash
  extend OnhlHash
  extend BToAHash

  validates :trading_day, uniqueness: true

  scope :last_num_months, ->(date) { where("trading_day >= ?", date) }
  scope :count_breach_fhh_sc, ->(period) { where("breach_fhh = ?", period.to_s).size }
  scope :count_breach_fhl_sc, ->(period) { where("breach_fhl = ?", period.to_s).size }
  scope :count_breach_both_sc, -> { where.not(breach_fhh: nil).where.not(breach_fhl: nil).size }
  scope :count_breach_either_sc, -> { where.not(breach_fhh: nil).or(Stats.where.not(breach_fhl: nil)).size }
  scope :count_breach_onh_sc, ->(period) { where("breach_onh = ?", period.to_s).size }
  scope :count_breach_onl_sc, ->(period) { where("breach_onl = ?", period.to_s).size }
  scope :count_breach_onhl_both_sc, -> { where.not(breach_onh: nil).where.not(breach_onl: nil).size }
  scope :count_breach_onhl_either_sc, -> { where.not(breach_onh: nil).or(Stats.where.not(breach_onl: nil)).size }
  scope :breach_ah_sc, -> { where.not(breach_ah: nil) }
  scope :breach_al_sc, -> { where.not(breach_al: nil) }
  scope :count_breach_ab_both_sc, -> { where.not(breach_ah: nil).where.not(breach_al: nil) }
  scope :count_breach_ab_either_sc, -> { where.not(breach_ah: nil).or(Stats.where.not(breach_al: nil)) }

  ##### Add data from PriceData table #####
  def self.populate_data_from_price_data_table
    add_trading_days_to_table
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
