class CLI
    attr_accessor :prompt, :logged_in, :current_player, :current_team, :pastel

    def clear_cli
        puts "\e[H\e[2J"
    end

    def greet
        clear_cli
        greeting = RubyFiglet::Figlet.new "Jimmy  and  Nick's \n Superhero  Battle  App!"
        puts greeting
    end

    def start_program
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
        login_create_process
        while @logged_in
            menu_prompt 
       
        end
    end

    def login_create_process
        user_response = player_name_prompt
        case 
        when user_response == "create" 
            create_player_name_prompt
        when Player.find_by(name: user_response)
            set_current_player(user_response)
            login_routine
        else
            puts "Not a valid player name, maybe create a new user 🤷 >"
            create_player_name_prompt
        end
    end

    def login_routine
        @logged_in = true
        check_current_team
    end

    def set_current_player(player_name)
        @current_player = Player.find_by(name: player_name)
    end

    def player_name_prompt
        prompt.ask("Enter your name to log in, or enter \"create\" to create a new player")
    end

    def create_player_name_prompt
        user_response = prompt.ask("Enter your name >")
        if Player.find_by(name: user_response)
            puts "#{user_response} is already a user! Please try again."
            login_create_process
        else
            create_player(user_response)
        end
    end

    def create_player(user_response)
        Player.create(name: user_response)
        set_current_player(user_response)
        login_routine
    end

    def check_current_team
        @current_team = current_player.teams.find_by(last_team: true)
    end

    def menu_prompt
        menu_response = prompt.select("Menu", ["Battle", "My Teams", "Leaderboard", "Logout", "Exit"]) unless current_team
        menu_response = prompt.select("You are currently logged in as #{current_player.name}.\nYour current team is #{@pastel.green(current_team.name)}", ["Battle", "My Teams", "Leaderboard", "Logout", "Exit"]) if current_team

        case menu_response
        when "Battle" 
            battle_menu if current_team
            puts "You do not currently have a team! Please create one to battle." unless current_team
        when "My Teams"
            my_teams_menu
        when "Leaderboard"
            leaderboard_menu if Team.all.any?
            puts "There have been no battles! You need to battle first for there to be a leaderboard." unless Team.all.any?
        when "Log Out"
            logout
        when "Exit"
            goodbye
        end
    end
    
    def current_player_teams
        current_player.teams.reload.map { |team| team.name } 
    end

    def current_player_teams_without_current_team
        current_player_teams - [current_team.name]
    end

    def create_team_menu
        fighter_response = prompt.ask("Please type in the name of the desired hero/villain! Or \"random\" for a surprise.")
        fighter = Fighter.find_by("LOWER(fighters.name)= ? ", fighter_response.downcase)
        if fighter_response == "random"
            Draft.create(team_id: current_team.id, fighter_id: rand(Fighter.all.count))
        elsif fighter
            Draft.create(team_id: current_team.id, fighter_id: fighter.id)
        else 
            puts "There is no such hero/villain with this name. Please try again."
        end

        current_team.print_composite if current_team.drafts.count == 3
        create_team_menu unless current_team.drafts.count == 3
    end

    def my_teams_menu
        menu_response = prompt.select("Manage your Teams", ["Create a team", current_player_teams], "Delete", "Cancel"  ) if !current_team
        menu_response = prompt.select("Manage your Teams", ["Create a team", @pastel.blue(current_team.name), current_player_teams_without_current_team ], "Delete", "Cancel"  ) if current_team
        if menu_response == "Create a team"
            puts "Your team will consist of three heroes/villains!"
            @current_team = Team.create(name: "")
            current_team.player = current_player
            create_team_menu
            current_team.set_team_name
            current_team.set_last_team
        elsif menu_response == "Delete"
            delete_character_menu
        elsif menu_response == "Cancel"
            #doing nothing returns to main menu
        else 
            @current_team = Team.find_by(name: @pastel.strip(menu_response))
            current_team.set_last_team
        end
    end

    def battle_menu
        menu_response = prompt.select("Choose a battle mode", ["Battle a player", "Random", "Back"])
        case menu_response
        when "Battle a player"
            battle_player_menu
        when "Random"
            random_opponent_id = (Player.player_ids_with_teams - [current_player.id]).sample
            opponent_team = Player.find(random_opponent_id).teams.sample
            puts "Your team is #{@pastel.green(current_team.name)}!"
            conduct_battle(current_team, opponent_team)
            # add end screen that requires tty-reader?
        when "Back"
            # nothing returns to menu
        end
    end

    def battle_player_menu
        menu_response = prompt.select("Choose a player", [Player.players_with_teams.pluck(:name) - [current_player.name] ], "Cancel")
        @battle_player_instance = Player.find_by(name: menu_response)
        case menu_response
        when "Cancel"
            battle_menu
        else
            player_menu(menu_response)
        end
    end

    def player_menu(player_name)
        menu_response = prompt.select("Choose a team", [Player.find_by(name: player_name).teams.pluck(:name)], "Cancel")
        case menu_response
        when "Cancel"
        else 
            opponent_team = Team.find_by(player: @battle_player_instance, name: menu_response)
            puts "Your team is #{@pastel.green(current_team.name)}!"
            puts "Your opponent is #{@pastel.red(opponent_team.name)}!"
            conduct_battle(current_team, opponent_team)
        end
    end

    def conduct_battle(team, opponent)
        battle = Battle.create(team: team, opponent: opponent)
        results = battle.results
        battle.tests.each do |test|
            announce_test_winner(results, battle, test)
        end

        winner = Team.find(battle.winner_id)

        puts @pastel.green("Your team has defeated the team of #{opponent.name} in #{results.values.(true)} of #{results.count} tests! Congratulations!") if winner == current_team 
        puts @pastel.red("You were defeated in #{results.values.count(false)} of #{results.count} tests. Better luck next time.") unless winner == current_team
        winner
    end

    def announce_test_winner(results, battle, test)
        battle_proclamation(test, battle.opponent)
        if results[test]
            testwinner = battle.team 
            sleep(1)
            puts "#{@pastel.green(testwinner.name)} has won this test of #{test}!"
            puts
            sleep(1)
        else 
            testwinner = battle.opponent
            sleep(1)
            puts "#{@pastel.red(testwinner.name)} has won this test of #{test}!"
            puts
            sleep(1)

        end
    end
    

    def battle_proclamation(test, opponent)
        puts "You are facing off in a test of #{test}!"
    end

    def fighting_sounds
        words = ["pow!", "zang!", "boom!"]
        words.shuffle.each do |word|
            sleep(1)
            spacing = rand(40)
            puts word.rjust(spacing)
        end
    end
  
    def delete_character_menu
        if current_player.teams.empty?
            puts "You have nothing to delete!"
            my_teams_menu
        elsif
            delete_team = prompt.select("Delete a Team", [@pastel.red(current_team.name), current_player_teams_without_current_team, "Cancel"])
            case delete_team 
            when "Cancel"
                my_teams_menu
            when current_team.name 
                puts "You can't delete your currently selected team!"
                delete_character_menu
            else
                confirmation = prompt.yes?('Are you sure?!?!')
                if confirmation
                    team = Team.find_by(name: delete_team)
                    Team.destroy(team.id)
                end
                my_teams_menu
            end
        end
    end

    def leaderboard_menu
        menu_response = prompt.select("Display a leaderboard", "Team", "Player", "Back")
        case menu_response
        when "Team"
            puts Leaderboard.new.render_table("construct_team_leaderboard")
        when "Player"
            puts Leaderboard.new.render_table("construct_player_leaderboard")
        when "Back"
            #doing nothing returns to while loop
        end
    end

    def logout
        @logged_in = false
        clear_cli
        puts "You have successfully logged out!"
        start_program
    end

    def goodbye
        clear_cli
        puts "Sad to see you go! Goodbye!"
        @logged_in = false
    end

end