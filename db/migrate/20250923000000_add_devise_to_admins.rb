class AddDeviseToAdmins < ActiveRecord::Migration[8.0]
  def change
    # Remove old password_digest
    remove_column :admins, :password_digest, :string

    # Add Devise fields
    add_column :admins, :encrypted_password, :string, null: false, default: ""
    add_column :admins, :reset_password_token, :string
    add_column :admins, :reset_password_sent_at, :datetime
    add_column :admins, :remember_created_at, :datetime

    # Add indexes
    add_index :admins, :email, unique: true
    add_index :admins, :reset_password_token, unique: true
  end
end
