class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :player1_score, null: false
      t.integer :player2_score, null: false

      t.timestamps
    end

    add_reference :games, :player1, references: :users, index: true
    add_foreign_key :games, :users, column: :player1_id

    add_reference :games, :player2, references: :users, index: true
    add_foreign_key :games, :users, column: :player2_id
  end
end
