class CLI
    attr_accessor :prompt, :logged_in, :current_player, :current_team, :pastel, :font

    def clear_cli
        puts "\e[H\e[2J"
    end

    def ten_second_wait
        puts
        prompt.keypress("Press any key to return, resumes automatically in 10 seconds ...", timeout: 10)
        puts
    end

    def five_second_wait
        puts
        prompt.keypress("Press any key to return, resumes automatically in 5 seconds ...", timeout: 5)
        puts
    end

    def indented(phrase)
        phrase.rjust(phrase.length + 5)
    end

    def greet
        clear_cli
        @font = TTY::Font.new(:straight)
        @pastel = Pastel.new
        greeting = pastel.yellow(font.write "Jimmy and Nick's Superhero Battler!")
        # greetingl2 = pastel.yellow(font.write "Superhero")
        # greetingl3 = pastel.yellow(font.write "Battler!")
        line_break
        puts greeting
        # puts greetingl2
        # puts greetingl3
        line_break
        puts
    end

    def start_program
        @prompt = TTY::Prompt.new(active_color: :cyan)
        login_create_process
        while @logged_in
            menu_prompt 
        end
    end

    def login_create_process
        user_response = prompt.ask("Enter your username to log in, or enter \"create\" to create a new player")
        case 
        when user_response.downcase == "create" 
            create_player_name_prompt
        when Player.find_by(name: user_response)
            login_routine(user_response)
        else
            puts indented("Not a valid player name, maybe create a new user 🤷")
            create_player_name_prompt
        end
    end

    def login_routine(username)
        @logged_in = true
        set_current_player(username)
        check_current_team
    end

    def set_current_player(player_name)
        @current_player = Player.find_by(name: player_name)
    end

    def create_player_name_prompt
        user_response = prompt.ask("Enter a new username")
        if Player.find_by(name: user_response)
            puts indented("#{user_response} is already a user! Please try again.")
            login_create_process
        else
            create_player(user_response)
        end
    end

    def create_player(user_response)
        Player.create(name: user_response)
        login_routine(user_response)
    end

    def check_current_team
        @current_team = current_player.teams.find_by(last_team: true)
    end

    def menu_prompt
        choices = ["Battle", "My Teams", "Leaderboard", "My Account", "Log Out", "Exit"]
        menu_response = prompt.select("Menu", choices ) unless current_team
        intro_with_current_team = "You are currently logged in as #{@pastel.green(current_player.name)}.\nYour current team is #{@pastel.green(current_team.name)}"
        menu_response = prompt.select(intro_with_current_team, choices) if current_team

        case menu_response
        when "Battle" 
            battle_menu if current_team && Player.players_with_teams.length > 1 
            if !current_team
                puts indented("You do not currently have a team! Please create one to battle.")
            end
            if !(Player.players_with_teams.length > 1)
                puts indented("There are no other players with teams for you to battle right now. Please make some friends to play this game with.")  
                ten_second_wait
            end
            puts
            line_break
        when "My Teams"
            my_teams_menu
        when "Leaderboard"
            leaderboard_menu if Battle.all.any?
            puts indented("There have been no battles! You need to battle first for there to be a leaderboard.") unless Battle.all.any?
            ten_second_wait unless Battle.all.any?
            puts
            line_break
        when "My Account"
            account_menu
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
        fighter_response = prompt.ask("Please type in the name of the desired hero/villain! Or #{@pastel.magenta("random")} for a surprise.")
        fighter = Fighter.find_by("LOWER(fighters.name)= ? ", fighter_response.downcase)
        if fighter_response == "random"
            draft = Draft.create(team_id: current_team.id, fighter_id: rand(Fighter.all.count))
            phrase = "#{@pastel.green(draft.fighter.name)} has randomly joined your team!"
            puts indented(phrase)
            puts 
        elsif fighter
            draft = Draft.create(team_id: current_team.id, fighter_id: fighter.id)
            phrase = "#{@pastel.green(draft.fighter.name)} has been joined your team!"
            puts indented(phrase)
            puts
        else 
            puts "There is no such hero/villain with this name. Please try again."
            puts
        end

        if current_team.drafts.count == 3
            current_team.print_composite
            current_team.set_team_name
            current_team.set_last_team
            puts
            puts font.write("#{current_team.name}")
        end
        create_team_menu unless current_team.drafts.count == 3
    end

    def my_teams_menu
        choices_no_team = [ "Create a team", current_player_teams, "Delete", "Cancel" ]
        choices = [
            "Create a team", 
            { name: @pastel.blue(current_team.name), value: current_team.name, disabled: "This is already your selected team!"},
             current_player_teams_without_current_team, "Delete", "Cancel"
            ] if current_team
        menu_response = prompt.select("Manage your Teams", choices_no_team ) if !current_team
        menu_response = prompt.select("Manage your Teams", choices ) if current_team
        if menu_response == "Create a team"
            puts indented("Your team will consist of three heroes/villains!")
            @current_team = Team.create(name: "")
            current_team.player = current_player
            create_team_menu
        elsif menu_response == "Delete"
            delete_character_menu
        elsif menu_response == "Cancel"
            #doing nothing returns to main menu
        else 
            @current_team = Team.find_by(name: menu_response)
            current_team.set_last_team
        end
    end

    def delete_character_menu
        if current_player.teams.empty?
            puts indented("You have nothing to delete!")
            ten_second_wait
            my_teams_menu
        elsif
            choices = [
                { name: @pastel.red(current_team.name), value: current_team.name, disabled: "You cannot delete your currently selected team."},
                current_player_teams_without_current_team, "Cancel"
            ]
            delete_team = prompt.select("Delete a Team", choices)
            case delete_team 
            when "Cancel"
                my_teams_menu
            when current_team.name 
                puts indented("You can't delete your currently selected team!")
                delete_character_menu
            else
                confirmation = prompt.yes?('Are you sure?!?!')
                if confirmation
                    team = Team.find_by(name: delete_team, id: current_player.id)
                    binding.pry
                    Team.destroy(team.id)
                end
                my_teams_menu
            end
        end
    end


    def battle_menu
        choices = [ "Random battle", "Battle a player", "Cancel" ]
        menu_response = prompt.select("Choose a battle mode", choices)
        case menu_response
        when "Random battle"
            random_opponent_id = (Player.player_ids_with_teams - [current_player.id]).sample
            opponent_team = Player.find(random_opponent_id).teams.sample
            puts indented("Your team is #{@pastel.green(current_team.name)}!")
            conduct_battle(current_team, opponent_team)
        when "Battle a player"
            battle_player_menu
        when "Cancel"
            # nothing returns to menu
        end
    end

    def battle_player_menu
        choices = [Player.players_with_teams.pluck(:name) - [current_player.name], "Cancel"]
        menu_response = prompt.select("Choose a player", choices)
        @battle_player_instance = Player.find_by(name: menu_response)
        case menu_response
        when "Cancel"
            battle_menu
        else
            player_menu(menu_response)
        end
    end

    def player_menu(player_name)
        menu_response = prompt.select("Choose a team", [Player.find_by(name: player_name).teams.pluck(:name), "Cancel"])
        case menu_response
        when "Cancel"
            battle_player_menu
        else 
            opponent_team = Team.find_by(player: @battle_player_instance, name: menu_response)
            puts indented("Your team is #{@pastel.green(current_team.name)}!")
            conduct_battle(current_team, opponent_team)
        end
    end

    def space_and_put(string)
        puts
        puts string
        puts
    end

    def line_break
        puts "=" * 124
    end

    def conduct_battle(team, opponent)
        puts indented("Your opponent is #{@pastel.red(opponent.name)}!")
        battle = Battle.create(team: team, opponent: opponent)

        line_break
        puts
        puts
        team.print_composite
        puts
        puts
        space_and_put(font.write("#{team.name}"))
        puts (font.write("VS."))
        space_and_put(font.write("#{opponent.name}"))
        puts
        puts
        opponent.print_composite
        puts
        puts
        line_break

        results = battle.results
        battle.tests.each do |test|
            announce_test_winner(results, battle, test)
        end

        winner = Team.find(battle.winner_id)
        puts @pastel.green("Your team has defeated the team of #{opponent.name} in #{results.values.count(true)} of #{results.count} tests! Congratulations!") if winner == current_team 
        puts @pastel.red("You were defeated in #{results.values.count(false)} of #{results.count} tests. Better luck next time.") unless winner == current_team
        ten_second_wait
    end

    def announce_test_winner(results, battle, test)
        battle_proclamation(test, battle.opponent)
        if results[test]
            testwinner = battle.team 
            sleep(1)
            puts "#{@pastel.green(testwinner.name)} has won this test of #{test}!"
            prompt.keypress("Press any key to continue, resumes automatically in 5 seconds ...", timeout: 5)
            line_break
        else 
            testwinner = battle.opponent
            sleep(1)
            puts "#{@pastel.red(testwinner.name)} has won this test of #{test}!"
            prompt.keypress("Press any key to continue, resumes automatically in 5 seconds ...", timeout: 5)
            line_break
        end
    end
    

    def battle_proclamation(test, opponent)
        puts "You are facing off in a test of #{test}!"
        fighting_sounds
    end

    def fighting_sounds
        words = ["pow!", "zang!", "boom!", "kablam", "katang", "hoom", "ping", "wham", "thwip"]
        words.shuffle.sample(3).each do |word|
            sleep(1)
            spacing = rand(70)
            puts word.rjust(spacing)
        end
    end

    def account_menu
        choices = [ "Change name", "Delete account", "Cancel" ]
        user_response = prompt.select("Manage your account", choices)
        case user_response
        when "Change name"
            change_name
        when "Delete account"
            delete_confirmation = prompt.yes?("Are you suuuuuure????")
            if delete_confirmation
                current_player.destroy
                puts "You have successfully deleted your account. Logging out in five seconds"
                sleep(5)
                logout
            else
                puts "OK. Welcome back, I guess." 
            end
        when "Cancel"
            #return to main
        end
    end

    def change_name
        user_response = prompt.ask("Enter your new name or type \"cancel\" to quit")
        if user_response.downcase == "cancel"
            
        elsif Player.find_by(name: user_response)
            puts "#{user_response} is already a user! Please try again."
            change_name
        else
            current_player.name = user_response
            current_player.save    
        end
    end  

    def leaderboard_menu
        choices = [ "Team", "Player", "Fighter", "Back" ]
        menu_response = prompt.select("Display a leaderboard", choices)
        case menu_response
        when "Team"
            puts Leaderboard.new.render_table("construct_team_leaderboard")
            ten_second_wait
            leaderboard_menu
        when "Player"
            puts Leaderboard.new.render_table("construct_player_leaderboard") if Player.all.sum(&:wins_count) > 0
            puts indented("No player has any wins yet! 😢") unless Player.all.sum(&:wins_count) > 0
            ten_second_wait
            leaderboard_menu
        when "Fighter"
            puts Leaderboard.new.render_table("construct_fighter_leaderboard")
            ten_second_wait
            leaderboard_menu
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