class AddWinsTrackingAttributesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :total_wins, :integer, null: false, default: 0
    add_column :users, :total_games, :integer, null: false, default: 0
  end
end
