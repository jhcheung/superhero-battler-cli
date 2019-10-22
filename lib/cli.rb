class CLI
    attr_accessor :prompt, :logged_in, :current_player, :current_team


    def greet 
        puts "Welcome to Jimmy and Nick's Superhero Battle App!"
    end

    def start_program
        @prompt = TTY::Prompt.new
        login_create_process
        menu_prompt if logged_in = true
    end

    def login_create_process
        user_response = player_name_prompt
        case 
        when user_response == "create" 
            create_player_name_prompt
            logged_in = true
        when Player.find_by(name: user_response)
            logged_in = true
            set_current_player(user_response)
        else
            puts "Not a valid player name, please create a new username"
            create_player_name_prompt
            logged_in = true
        end
    end

    def set_current_player(player_name)
        @current_player = Player.find_by(name: player_name)
    end

    def player_name_prompt
        prompt.ask("Enter your name to log in, or enter \"create\" to create a new player")
    end

    def create_player_name_prompt
        name = prompt.ask("Enter your name:")
        if Player.find_by(name: name)
            puts "#{name} is already a user! Please try again."
            login_create_process
        else
            Player.create(name: name)
        end
    end

    def menu_prompt
        menu_response = prompt.select("Menu >", ["Battle", "My Teams", "Leaderboard", "Logout", "Exit"])
        case menu_response
        when "Battle" 
            #battle function
        when "My Teams"
            my_teams_menu
        when "Leaderboard"
            #leaderboard function
        when "Logout"
            logout
        when "Exit"
            goodbye
        end
    end
    
    def current_player_teams
        current_player.teams.map { |team| team.name } 
    end

    def my_teams_menu
        menu_response = prompt.select("Your Teams >", ["Create a team", current_player_teams ]  )
        if menu_response == "Create a team"
            puts "Your team will consist of three heroes/villains!"
            @current_team = Team.create(name: "")
            current_team.player = current_player
            create_team_menu
            current_team.set_team_name
            current_team.set_last_team
            current_team.save
        else
            #do something with current_player_teams
        end
    end

    def create_team_menu
        fighter_response = prompt.ask("Please type in the name of the desired hero/villain! Or random for a surprise.")
        fighter = Fighter.find_by("LOWER(fighters.name)= ? ", fighter_response.downcase)
        if fighter_response == "random"
            Draft.create(team_id: current_team.id, fighter_id: rand(Fighter.all.count))
        elsif fighter
            Draft.create(team_id: current_team.id, fighter_id: fighter.id)
        else 
            puts "404 not found"
        end

        create_team_menu unless current_team.drafts.count == 3
    end

    def logout
        logged_in = false
        start_program
    end

    def goodbye
        puts "Sad to see you go! Goodbye!"
        :break
    end

end