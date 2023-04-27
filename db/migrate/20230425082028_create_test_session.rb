class CreateTestSession < ActiveRecord::Migration[7.0]
  def change
    create_table :test_sessions, id: :uuid do |t|
      t.string :status, default: 'acive'
      t.timestamps
    end
  end
end
