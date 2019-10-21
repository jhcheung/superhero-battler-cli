class Player < ActiveRecord::Base
    has_many :teams
    has_many :battles

    # def login_or_create_user
    #     puts "Enter your name to log in, or enter \"create\" to create a new player > "
    #     user_input = gets.chomp
    #     if user_input == "create" 
    #         create_player
    #     elsif Player.find_by(name: user_input)
    #         my_teams #see #my_teams method in team.rb
    #     else
    #         puts "Not a valid player name, create new user >"
    #         create_player
    #     end
    #     # prompt = TTY::Prompt.new
        # user_input = prompt.select("Log In or Create New User:", ["Log In", "Create New User"])
        # if user_input == "Log In"
        #     choose_player
        # else
        #     create_user
        # end
    # end
       
    def self.create_player
        puts "Enter your name >"
        user_input = gets.chomp
        new_player = Player.new(name: user_input)
        puts new_player.name
    end
    
end

