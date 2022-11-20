class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :content
      t.jsonb :to

      t.timestamps
    end
  end
end
