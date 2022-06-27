module AToBHash

  def a_to_b_stats_hash(total)
    period = {
      breach_high: as_percent_of(self.breach_ah_sc.size, total),
      breach_high_avg: mean_ticks(breach_ah_to_array),
      breach_low: as_percent_of(self.breach_al_sc.size, total),
      breach_low_avg: mean_ticks(breach_al_to_array),
      breach_both: as_percent_of(self.count_breach_ab_both_sc.size, total),
      breach_both_avg: mean_ticks(breach_ab_both_to_array),
      breach_either: as_percent_of(self.count_breach_ab_either_sc.size, total),
      breach_either_avg: mean_ticks(breach_ab_either_to_array)
    }
  end

  def breach_ah_to_array
    self.breach_ah_sc.pluck(:breach_ah).map { |i| i.to_f }
  end

  def breach_al_to_array
    self.breach_ah_sc.pluck(:breach_al).map { |i| i.to_f }
  end

  def breach_ab_both_to_array
    self.count_breach_ab_both_sc.pluck(:breach_ah, :breach_al).flatten.map { |i| i.to_f }
  end

  def breach_ab_either_to_array
    self.count_breach_ab_either_sc.pluck(:breach_ah, :breach_al).flatten.compact.map { |i| i.to_f }
  end
end
