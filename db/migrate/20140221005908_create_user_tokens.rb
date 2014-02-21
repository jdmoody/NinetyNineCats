class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.timestamps
    end

    add_index :user_tokens, :session_token, unique: true
    add_index :user_tokens, :user_id
  end
end
