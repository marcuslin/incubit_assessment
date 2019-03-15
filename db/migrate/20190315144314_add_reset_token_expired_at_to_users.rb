class AddResetTokenExpiredAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reset_token_expired_at, :datetime
  end
end
