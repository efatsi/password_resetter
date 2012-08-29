class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.string :identifier
      t.string :password
      t.string :password_confirmation
      t.string :reset_token
      t.datetime :reset_sent_at
      
      t.timestamps
    end
  end
end