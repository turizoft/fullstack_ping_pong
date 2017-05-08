class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validations
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :username, format: { with: /\A[\w\d-]*\z/ }
  validates :username, length: { in: 3..16 }
  validates :email, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/ }

  # Callbacks
  before_save :format_attributes
  after_create :self_update_rankings!

  def initial
    username[0].upcase
  end

  def self.all_except(user)
    where.not(id: user)
  end

  def win_ratio
    if total_games == 0
      0
    else
      100 * total_wins / total_games
    end
  end

  def self.update_rankings!
    User.find_each(batch_size: 1000) do |user|
      user.update_attributes(elo_ranking: User.order(elo_points: :desc, username: :asc).pluck(:id).index(user.id) + 1)
    end
  end

  def self_update_rankings!
    self.class.update_rankings!
  end

  private
  def format_attributes
    self.username.downcase!
    self.email.downcase!
  end
end
