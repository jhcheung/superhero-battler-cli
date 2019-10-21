class Team < ActiveRecord::Base
    belongs_to :player
    
    has_many :battles
    has_many :opponents, through: :battles
    
    has_many :drafts
    has_many :fighters, through: :drafts

    def my_teams
        #show names of all team
    end
    
end



    
# has_many :battles, foreign_key: opponent_id, class_name: 'Battle'
# has_many :opponents, through: :battles
# has_many :userteams, through: :battles