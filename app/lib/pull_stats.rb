module PullStats

  def ffhl_thing
    hash = {
      day: fill_breach_fhhl[0],
      period: fill_breach_fhhl[1],
      accum: fill_breach_fhhl[2]
    }
  end

  def fill_breach_fhhl
    period = empty_stat_hash_periods
    day = empty_stat_hash_days

    period[:high][:B] = 1
    period[:high][:C] = 10

    accum = add_accum_stats_hash(period)

    return day, period, accum
  end

  # def count_breach
  #   hash = empty_periods_hash
  #   hash.each do |k, v|
  #     hash[k] = Stats.where(breach_fhl: k.to_s).size
  #   end
  # end

  def count_breach
    hash = empty_periods_hash
    hash.each do |k, v|
      hash[k] = get_breach_fhl(k).size
    end
  end

  def get_breach_fhl(period)
    Stats.where("breach_fhl = ?", period.to_s)
  end

  def fhhl_breaches
    breach_fhl = count_breach
  end
end
