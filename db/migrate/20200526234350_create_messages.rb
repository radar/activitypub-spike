class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :sent_messages do |t|
      t.references :from, foreign_key: { to_table: :users }
      t.jsonb :to

      t.text :content

      t.timestamps limit: 6
    end

    create_table :received_messages do |t|
      t.references :from, foreign_key: { to_table: :users }
      t.references :to, foreign_key: { to_table: :users }

      t.text :content

      t.timestamps limit: 6
    end
  end
end
