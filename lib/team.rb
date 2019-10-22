class Team < ActiveRecord::Base
    belongs_to :player
    
    has_many :battles
    has_many :opponents, through: :battles
    
    has_many :drafts
    has_many :fighters, through: :drafts

    def set_team_name
        team_names = drafts.map { |draft| draft.fighter.name }
        team_names.sort
        self.name = team_names.join(" | ")  
        save      
    end
    
    def set_last_team
        players_teams = self.player.teams
        players_teams.each do |player_team|
            player_team.last_team = false
        end
        self.last_team = true
    end


end



    
# has_many :battles, foreign_key: opponent_id, class_name: 'Battle'
# has_many :opponents, through: :battles
# has_many :userteams, through: :battles