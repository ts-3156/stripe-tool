class CreateActiveCheckoutSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :active_checkout_sessions do |t|
      t.bigint :user_id, null: false
      t.string :target_id, null: false
      t.timestamp :expired_at
      t.timestamp :completed_at
      t.timestamps null: false
      t.index :user_id
      t.index :target_id
    end
  end
end
