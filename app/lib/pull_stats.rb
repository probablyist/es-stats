module PullStats


  def fhhl_stats_hash
    fhhl_stats = {
      period_stats: fhhl_period_stats,
      day: fhhl_day_stats
    }
  end

  def fhhl_period_stats(total)
    period_stats = {
      fhh_period: hash_to_percent(self.count_breach_fhh_to_hash, total),
      fhl_period: hash_to_percent(self.count_breach_fhl_to_hash, total),
      acc_fhh: hash_to_percent(self.accum_count_breach_fhh_to_hash, total),
      acc_fhl: hash_to_percent(self.accum_count_breach_fhl_to_hash, total)
    }
  end

  def fhhl_day_stats(total)
    day = {
      fhhl_both: as_percent_of(self.count_breach_both_sc, total),
      fhhl_either: as_percent_of(self.count_breach_either_sc, total)
    }
  end

  def count_breach_fhh_to_hash
    hash = empty_periods_hash.except(:A, :B)
    hash.each do |k, v|
      hash[k] = self.count_breach_fhh_sc(k)
    end
  end

  def accum_count_breach_fhh_to_hash
    accumulate_periods(count_breach_fhh_to_hash)
  end

  def accum_count_breach_fhl_to_hash
    accumulate_periods(count_breach_fhl_to_hash)
  end

  def count_breach_fhl_to_hash
    hash = empty_periods_hash.except(:A, :B)
    hash.each do |k, v|
      hash[k] = self.count_breach_fhl_sc(k)
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
