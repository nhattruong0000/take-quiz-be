class CreateCard < ActiveRecord::Migration[7.0]
  def change
    create_table :cards, id: :uuid do |t|
      t.string :question, null: false
      t.string :answer, null: false
      t.string :picture_url
      t.boolean :set_favorite, default: false
      t.integer :success_count, default: 0
      t.integer :failed_count, default: 0
      t.integer :study_count, default: 0
      t.datetime :study_last_time
      t.integer :order_no, default: 0
      t.string :status, default: 'active'
      t.boolean :is_public, default: false
      t.uuid :card_collection_id, null: false
      t.uuid :user_id, null: false
      t.timestamps
    end

    # add index to question, answer, status, is_public
    add_index :cards, :question, using: :gin, opclass: :gin_trgm_ops
    add_index :cards, :answer, using: :gin, opclass: :gin_trgm_ops
    add_index :cards, :status, using: :gin, opclass: :gin_trgm_ops
    add_index :cards, :is_public
    add_index :cards, :card_collection_id
    add_index :cards, :user_id
  end
end


