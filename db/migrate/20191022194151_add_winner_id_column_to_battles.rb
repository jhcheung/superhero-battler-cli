class AddWinnerIdColumnToBattles < ActiveRecord::Migration[6.0]
  def change
    add_column :battles, :winner_id, :integer
  end
end
