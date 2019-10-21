class Fighter < ActiveRecord::Base
    has_many :drafts
    has_many :teams, through: :drafts
end