class RenameForgetPasswordTokenInUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :forget_password_token, :reset_password_token
  end
end
