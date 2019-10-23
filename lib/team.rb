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
            if player_team.last_team
                player_team.last_team = false
                player_team.save
            end 
        end
        self.last_team = true
        self.save
    end

    def print_composite
        Fighter.print_composite_image(self.fighters[0], self.fighters[1], self.fighters[2])
    end

    # def self.execute_sql(*sql_array)     
    #     connection.execute(send(:sanitize_sql_array, sql_array))
    # end




end


#notes
#use tty table in iteration
# iterate over all battles and check count.
    
# has_many :battles, foreign_key: opponent_id, class_name: 'Battle'
# has_many :opponents, through: :battles
# has_many :userteams, through: :battles