class AddSourceToReceivedMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :received_messages, :source, null: false, foreign_key: { to_table: :sent_messages }
  end
end
