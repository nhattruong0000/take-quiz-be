class CreateTestCard < ActiveRecord::Migration[7.0]
  def change
    create_table :test_cards, id: :uuid do |t|
      t.uuid :card_id, null: false
      t.uuid :test_session_id, null: false
      t.string :result
      t.timestamps
    end

    add_index :test_cards, :card_id
    add_index :test_cards, :test_session_id
    add_index :test_cards, :result, using: :gin, opclass: :gin_trgm_ops
  end
end
