class CreateTestSession < ActiveRecord::Migration[7.0]
  def change
    create_table :test_sessions, id: :uuid do |t|
      t.uuid :card_collection_id, null: false
      t.string :status, default: 'acive'
      t.jsonb :configs, default: {}
      t.integer :order_no, autoincrement: true
      t.timestamps
    end

    add_index :test_sessions, :status, using: :gin, opclass: :gin_trgm_ops
  end
end
