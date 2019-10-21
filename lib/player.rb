class Player < ActiveRecord::Base
    has_many :teams
    has_many :battles

    prompt = TTY::Prompt.new

    def login_or_create_user
        user_input = prompt.select("Log In or Create New User:", ["Log In", "Create New User"])
    end

end


