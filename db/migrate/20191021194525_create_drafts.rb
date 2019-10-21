class CreateDrafts < ActiveRecord::Migration[6.0]
  def change
    create_table :drafts do |t|
      t.integer :team_id
      t.integer :fighter_id
    end
  end
end
