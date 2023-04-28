class CreateStudyCard < ActiveRecord::Migration[7.0]
  def change
    create_table :study_cards, id: :uuid do |t|
      t.uuid :card_id, null: false
      t.uuid :study_session_id, null: false
      t.integer :question_type, null: false #0: true in list, 1: true or false
      t.jsonb :questions, null: false
      t.jsonb :answers, null: false
      t.jsonb :results, null: false
      t.timestamps
    end

    add_index :study_cards, :card_id
    add_index :study_cards, :study_session_id
    add_index :study_cards, :questions, using: :gin
    add_index :study_cards, :answers, using: :gin
    add_index :study_cards, :results, using: :gin
  end
end
