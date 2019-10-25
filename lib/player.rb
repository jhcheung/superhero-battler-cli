class Player < ActiveRecord::Base
    has_many :teams
    has_many :battles

    def wins_count #checks teams and sums up their player_wins count
        teams.sum(&:player_wins_count) 
    end

    def self.players_with_teams 
        self.all.select { |player| player.teams.count > 0 }
    end

    def self.player_ids_with_teams
        players_with_teams.map { |player| player.id }
    end

    def self.team_ids 
        teams.pluck(:id)
    end

    def self.names
        self.pluck(:names)
    end

end

