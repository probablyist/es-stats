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


  def add_accum_stats_hash(hash)
    hash.each do |k, v|
      hash[k] = accumulate_periods(v)
    end
  end

  def accumulate_periods_x
    sum = 0
    transform_values { |v| sum += v }
  end
end
