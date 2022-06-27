module OnhlHash

  def onhl_stats_hash
    onhl_stats = {
      period_stats: onhl_period_stats,
      day: onhl_day_stats
    }
  end

  def onhl_period_stats(total)
    period_stats = {
      onh_period: hash_to_percent(self.count_breach_onh_to_hash, total),
      onl_period: hash_to_percent(self.count_breach_onl_to_hash, total),
      acc_onh: hash_to_percent(self.accum_count_breach_onh_to_hash, total),
      acc_onl: hash_to_percent(self.accum_count_breach_onl_to_hash, total)
    }
  end

  def onhl_day_stats(total)
    day = {
      onhl_both: as_percent_of(self.count_breach_onhl_both_sc, total),
      onhl_either: as_percent_of(self.count_breach_onhl_either_sc, total)
    }
  end

  def count_breach_onh_to_hash
    hash = empty_periods_hash
    hash.each do |k, v|
      hash[k] = self.count_breach_onh_sc(k)
    end
  end

  def count_breach_onl_to_hash
    hash = empty_periods_hash
    hash.each do |k, v|
      hash[k] = self.count_breach_onl_sc(k)
    end
  end

  def accum_count_breach_onh_to_hash
    accumulate_periods(count_breach_onh_to_hash)
  end

  def accum_count_breach_onl_to_hash
    accumulate_periods(count_breach_onl_to_hash)
  end
end
