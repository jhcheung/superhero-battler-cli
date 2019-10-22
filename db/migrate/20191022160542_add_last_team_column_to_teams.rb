class AddLastTeamColumnToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :last_team, :boolean
  end
end
