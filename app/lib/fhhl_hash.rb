module FhhlHash

  # Builds hash containing statistics for FHHL by period
  def fhhl_period_stats(total)
    period_stats = {
      fhh_period: hash_to_percent(self.count_breach_fhh_to_hash, total),
      fhl_period: hash_to_percent(self.count_breach_fhl_to_hash, total),
      acc_fhh: hash_to_percent(self.accum_count_breach_fhh_to_hash, total),
      acc_fhl: hash_to_percent(self.accum_count_breach_fhl_to_hash, total)
    }
  end

  # Builds hash containing statistics for FHHL by day
  def fhhl_day_stats(total)
    day = {
      fhhl_both: as_percent_of(self.count_breach_both_sc, total),
      fhhl_either: as_percent_of(self.count_breach_either_sc, total)
    }
  end

  # Adds occurances of first breach high for each period
  def count_breach_fhh_to_hash
    hash = empty_periods_hash.except(:A, :B)
    hash.each do |k, v|
      hash[k] = self.count_breach_fhh_sc(k)
    end
  end

  # Adds occurances of first breach low for each period
  def count_breach_fhl_to_hash
    hash = empty_periods_hash.except(:A, :B)
    hash.each do |k, v|
      hash[k] = self.count_breach_fhl_sc(k)
    end
  end

  # Adds sum of previous period counts to each period
  def accum_count_breach_fhh_to_hash
    accumulate_periods(count_breach_fhh_to_hash)
  end

  def accum_count_breach_fhl_to_hash
    accumulate_periods(count_breach_fhl_to_hash)
  end
end
