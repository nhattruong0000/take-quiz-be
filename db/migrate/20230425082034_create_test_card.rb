class CreateTestCard < ActiveRecord::Migration[7.0]
  def change
    create_table :test_cards, id: :uuid do |t|
      t.uuid :card_id, null: false
      t.uuid :test_session_id, null: false
      t.integer :question_type, null: false #0: true in list, 1: true or false
      t.jsonb :questions, null: false
      t.jsonb :answers, null: false
      t.jsonb :results, null: false
      t.timestamps
    end

    add_index :test_cards, :card_id
    add_index :test_cards, :test_session_id
    add_index :test_cards, :questions, using: :gin
    add_index :test_cards, :answers, using: :gin
    add_index :test_cards, :results, using: :gin
  end
end
