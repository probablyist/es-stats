module StatsHash

  def empty_periods_hash
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

  def empty_b_period_hash
    b_period = {
      B: 0
    }
  end

  def empty_stat_hash_periods
    period_stats = {
      high: empty_periods_hash,
      low: empty_periods_hash,
      either: empty_periods_hash,
      both: empty_periods_hash
    }
  end

  def empty_stat_hash_days
    day_stats = {
      high: 0,
      low: 0,
      either: 0,
      both: 0
    }
  end

  def add_accum_stats_hash(hash)
    hash.each do |k, v|
      hash[k] = accumulate_periods(v)
    end
  end

  def accumulate_periods(hash)
    sum = 0
    hash.transform_values { |v| sum += v }
  end

  def hash_to_percent(hash, total)
    hash.each do |k, v|
      hash[k] = as_percent_of(v, total) #unless hash[k].blank?
    end
    hash
  end

  def as_percent_of(numerator, denominator)
    ActiveSupport::NumberHelper.number_to_percentage(numerator.to_f / denominator.to_f * 100, precision: 2)
  end

end
