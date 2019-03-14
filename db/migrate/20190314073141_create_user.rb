class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :confirmation_token
      t.string :forget_password_token
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :confirmed_at
    end
  end
end
