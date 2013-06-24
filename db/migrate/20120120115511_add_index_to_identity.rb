class AddIndexToIdentity < ActiveRecord::Migration
  def change
    add_index :identities, :email
  end
end
