class CreateStudyCard < ActiveRecord::Migration[7.0]
  def change
    create_table :study_cards, id: :uuid do |t|
      t.uuid :card_id, null: false
      t.uuid :study_session_id, null: false
      t.string :result
      t.timestamps
    end

    add_index :study_cards, :card_id
    add_index :study_cards, :study_session_id
    add_index :study_cards, :result, using: :gin, opclass: :gin_trgm_ops
  end
end
