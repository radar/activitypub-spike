class RenameUsersToActors < ActiveRecord::Migration[7.0]
  def change
    rename_table :users, :actors

    rename_column :followings, :user_id, :actor_id
  end
end
