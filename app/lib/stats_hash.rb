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
      hash[k] = as_percent_of(v, total)
    end
    hash
  end

  def as_percent_of(numerator, denominator)
    ActiveSupport::NumberHelper.number_to_percentage(numerator.to_f / denominator.to_f * 100, precision: 2)
  end

  def mean_ticks(array)
    mean = array.sum(0.0) / array.size
    mean = (mean * 4).round / 4.0
  end

end
