class Recordsdestroytables < ActiveRecord::Migration[6.1]
  def change
    drop_table :chats
    drop_table :chat_messages
  end
end
