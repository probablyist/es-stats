class StatsController < ApplicationController
  # GET /stats or /stats.json
  def index
    @stats = Stats.all.order(:trading_day)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stats.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stat_params
      params.require(:stat).permit(:trading_day, :breach_onh, :breach_onl, :breach_fhh, :breach_fhl, :breach_ah, :breach_al)
    end
end
