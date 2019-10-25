class Team < ActiveRecord::Base
    belongs_to :player
    
    has_many :battles
    has_many :opponents, through: :battles
    
    has_many :drafts
    has_many :fighters, through: :drafts

    def overall_wins #returns wins, either with the team as an opponent or player, doesn't disciminate if the player or opponent won
        Battle.all.select { |battle| battle.winner_id == id } #checks all battles because #battles activerecord doesn't give battles where opponent is the team
    end

    def overall_wins_count
        overall_wins.count
    end

    def player_wins #only wins as a player, no wins from opponent
        battles.select { |battle| battle.winner_id == id }
    end

    def player_wins_count
        player_wins.count
    end

    def set_team_name
        team_names = drafts.map { |draft| draft.fighter.name }
        self.name = team_names.join(" | ")  
        save      
    end
    
    def set_last_team
        players_teams = self.player.teams
        players_teams.each do |player_team| #looks through all of the partner teams of this team and sets their last_team to false
            if player_team.last_team
                player_team.last_team = false
                player_team.save
            end 
        end
        self.last_team = true #set last_team to true
        self.save
    end

    def print_composite
        Fighter.print_composite_image(self.fighters[0], self.fighters[1], self.fighters[2])
    end

    def self.teams_with_wins #returns teams that actually have wins
        Team.all.select { |team| team.overall_wins.count > 0 }
    end

    def self.fighters_from_teams_with_wins #got helped by teams_with_wins
        teams_with_wins.map { |team| team.fighters }.flatten.uniq
    end
end