class CreateStudySession < ActiveRecord::Migration[7.0]
  def change
    create_table :study_sessions, id: :uuid do |t|
      t.uuid :card_collection_id, null: false
      t.string :status, default: 'active'
      t.jsonb :configs, default: {}
      t.integer :order_no, autoincrement: true
      t.timestamps
    end

    add_index :study_sessions, :status, using: :gin, opclass: :gin_trgm_ops
  end
end
