class CreateCardCollection < ActiveRecord::Migration[7.0]
  def change
    create_table :card_collections, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.uuid :user_id, null: false
      t.string :status, null: false, default: "active"
      t.timestamps
    end

    add_index :card_collections, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :card_collections, :status
    add_index :card_collections, :user_id
  end
end

