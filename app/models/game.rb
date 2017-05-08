class Game < ApplicationRecord
  # Asociations
  belongs_to :player1, class_name: 'User', foreign_key: 'player1_id'
  belongs_to :player2, class_name: 'User', foreign_key: 'player2_id'

  # Validations
  validates :player1_id, presence: true, numericality: { only_integer: true }
  validates :player2_id, presence: true, numericality: { only_integer: true }
  validates :player1_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 21 }
  validates :player2_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 21 }
  validate :ping_pong_rules
  validate :cant_play_yourself

  def log_match
    # Calculate ELO ranking update for both users
    match = EloRating::Match.new
    match.add_player(rating: player1.elo_points, winner: wins?(player1))
    match.add_player(rating: player2.elo_points, winner: wins?(player2))
    new_points = match.updated_ratings # => [1988, 2012]

    # Can't update elo points and ranking at once se we need to save the user each time
    player1.update_attributes(elo_points: new_points[0], total_games: player1.total_games + 1, total_wins: player1.total_wins + (wins?(player1) ? 1 : 0))
    player2.update_attributes(elo_points: new_points[1], total_games: player2.total_games + 1, total_wins: player2.total_wins + (wins?(player2) ? 1 : 0))

    # Cache user ranking for better performance
    User.update_rankings!
  end

  def self.user_games(current_user)
    Game.where(player1_id: current_user.id).or(Game.where(player2_id: current_user.id)).includes(:player1, :player2)
  end

  def rival(user)
    self.player1_id == user.id ? player2 : player1
  end

  def rival_score(user)
    self.player1_id != user.id ? player1_score : player2_score
  end

  def user_score(user)
    self.player1_id == user.id ? player1_score : player2_score
  end

  def match_result(user)
    if (player1_score - player2_score).abs < 2
      'D'
    else
      (player1_score > player2_score) == (self.player1_id == user.id) ? 'W' : 'L'
    end
  end

  def wins?(user)
    match_result(user) == 'W'
  end

  protected
  def cant_play_yourself
    if player1_id == player2_id
      errors.add(:player2_id, 'Can not play yourself')
    end
  end

  def ping_pong_rules
    # Clamp values, between 21 and 19, since anything bellow 19 is irrelevant
    sc1 = [player1_score, 19].max
    sc2 = [player2_score, 19].max
    sc = "#{sc1}-#{sc2}"

    # Avoid entangled boolean logic by splitting results into categories and use direct comparison
    # Note: 21-19, 19-21, and 20-20 are the only valid scores
    error_codes = {
      "19-19" => ['player1_score', 'any player needs to reach 21 points or tie'],
      "20-19" => ['player1_score', 'any player needs to reach 21 points or tie'],
      "19-20" => ['player2_score', 'any player needs to reach 21 points or tie'],
      "21-20" => ['player2_score', 'a player must win by a 2 point margin'],
      "20-21" => ['player1_score', 'a player must win by a 2 point margin'],
      "21-21" => ['player1_score', 'players can not tie beyond 20 points']
    }

    if error_codes[sc].present?
      errors.add(error_codes[sc][0].to_sym, error_codes[sc][1])
    end
  end
end
