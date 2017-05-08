class GamesController < ApplicationController
  before_action :load_rivals, only: [:new, :create]
  def index
    @games = Game.user_games(current_user).order(created_at: :desc)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params.merge(player1_id: current_user.id))
    if @game.save
      @game.log_match
      flash[:alert] = 'Game created successfully'
      redirect_to games_path
    else
      render 'new'
    end
  end

  protected
  def load_rivals
    @rivals = User.all_except current_user
  end
  def game_params
    params.require(:game).permit(:player1_score, :player2_score, :player2_id)
  end
end
