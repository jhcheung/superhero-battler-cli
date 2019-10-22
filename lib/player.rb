class Player < ActiveRecord::Base
    has_many :teams
    has_many :battles

    def self.players_with_teams
        self.all.select { |player| player.teams.count > 0 }
    end

    def self.player_ids_with_teams
        players_with_teams.map { |player| player.id }
    end
end

