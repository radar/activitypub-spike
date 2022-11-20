class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username

      t.timestamps
    end

    create_table :followings, id: false do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :user
    end
  end
end
