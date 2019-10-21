class Battle < ActiveRecord::Base
    belongs_to :team
    belongs_to :opponent, class_name: 'Team'
end