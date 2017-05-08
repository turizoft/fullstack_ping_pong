require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    before do
      @incomplete_user = User.new(username: 'user1')
      @complete_user = create(:user)
    end

    it "can't be saved without all required fields" do
      expect(@incomplete_user).not_to be_valid
    end

    it "can be saved with all required fields" do
      expect(@complete_user).to be_valid
    end

    it "username must be unique" do
      repeated_user = User.new(username: 'johndoe', email: 'email1@email.com', password: '123456')

      expect(repeated_user).not_to be_valid
      expect(repeated_user.errors[:username].size).to eq(1)
    end

    it "email must be unique" do
      repeated_user = User.new(username: 'user1', email: 'johndoe@email.com', password: '123456')

      expect(repeated_user).not_to be_valid
      expect(repeated_user.errors[:email].size).to eq(2)
    end
  end

  context "methods" do
    before do
      @user = create(:user)
    end

    it "correctly generates the initial letter" do
      expect(@user.initial).to eq('J')
    end

    it "correctly calculates the win ratio" do
      @user.total_wins = 3
      @user.total_games = 6
      expect(@user.win_ratio).to eq(50)
    end
  end
end