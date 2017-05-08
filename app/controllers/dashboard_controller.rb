class DashboardController < ApplicationController
  def index
    @games = Game.user_games(current_user).order(created_at: :desc).first(3)
    @ranked_users = User.order(:elo_ranking).first(10)
  end

  def ranking
    @ranked_users = User.order(:elo_ranking)
  end
end
