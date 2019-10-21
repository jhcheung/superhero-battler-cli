class CreateBattles < ActiveRecord::Migration[6.0]
  def change
    create_table :battles do |t|
      t.integer :team_id
      t.integer :opponent_id
    end
  end
end
