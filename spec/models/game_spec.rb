require 'rails_helper'

RSpec.describe Game, type: :model do
  context "validations" do
    before do
      @incomplete_game = Game.new(player1_score: 0, player2_score: 21)
    end

    it "can't be saved without all required fields" do
      expect(@incomplete_game).not_to be_valid
    end
  end

  context "gameplay" do
    before do
      @user1 = User.create(username: 'user1', email: 'email1@email.com', password: '123456')
      @user2 = User.create(username: 'user2', email: 'email2@email.com', password: '123456')
      @game = Game.new(player1_score: 0, player2_score: 21, player1_id: @user1.id, player2_id: @user2.id)
      @tied_game = Game.new(player1_score: 20, player2_score: 20, player1_id: @user1.id, player2_id: @user2.id)
      @invalid_game = Game.new(player1_score: 21, player2_score: 20, player1_id: @user1.id, player2_id: @user2.id)
    end

    it "calculates the match result correctly" do
      expect(@game.match_result(@user1)).to eq('L')
      expect(@game.match_result(@user2)).to eq('W')
      expect(@tied_game.match_result(@user1)).to eq('D')
      expect(@tied_game.match_result(@user2)).to eq('D')
    end

    it "can't be won for less than 2 points" do
      expect(@invalid_game).not_to be_valid
    end
  end
end