class CLI
    attr_accessor :prompt


    def greet 
        puts "Welcome to Jimmy and Nick's Superhero Battle App!"
    end

    def start_program
        @prompt = TTY::Prompt.new
        user_response = username_prompt
        case 
        when user_response == "create" 
            create_username_prompt
            menu_prompt
        when Player.find_by(name: user_response)
            menu_prompt
        else
            puts "Not a valid player name, please create a new username"
            create_username_prompt
            menu_prompt
        end
    end

    def username_prompt
        prompt.ask("Enter your name to log in, or enter \"create\" to create a new player")
    end

    def create_username_prompt
        name = prompt.ask("Enter your name:")
        Player.create(name: name)
    end

    # def show_teams_prompt
    #     teams = Team.all.map {|team| team.name}
    #     prompt = TTY::Prompt.new
    #     prompt.select("Choose your team >", [teams.each {|names| puts names}])
    # end

    def menu_prompt
        menu_response = prompt.select("Menu >", ["Battle", "My Teams", "Leaderboard", "Exit"])
        case menu_response
        when "Battle" 
            #battle function
        when "My Teams"
            #my_teams function
        when "Leaderboard"
            #leaderboard function
        when "Exit"
            goodbye
        end
    end

    def goodbye
        puts "Sad to see you go! Goodbye!"
        :exit
    end

end