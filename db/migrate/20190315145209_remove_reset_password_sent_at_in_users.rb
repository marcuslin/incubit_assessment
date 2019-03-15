class RemoveResetPasswordSentAtInUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :reset_password_sent_at
  end
end
