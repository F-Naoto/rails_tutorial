class AddNameToUser < ActiveRecord::Migration[6.0]
  def change
    # この行を編集する
    add_column :users, :name, :string
  end
end
