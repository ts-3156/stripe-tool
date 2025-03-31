class CreateStripeLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_logs do |t|
      t.bigint :user_id
      t.string :event_type, null: false
      t.string :target_id, null: false
      t.string :event_id, null: false
      t.index :created_at
      t.timestamps null: false
    end
  end
end
