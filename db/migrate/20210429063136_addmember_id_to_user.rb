class AddmemberIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :memberId, :string, :unique => true, :null => false, :default =>""
  end
end
