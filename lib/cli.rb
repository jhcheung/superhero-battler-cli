class CLI
    attr_accessor :prompt, :logged_in, :current_player, :current_team


    def greet 
        puts "Welcome to Jimmy and Nick's Superhero Battle App!"
    end

    def start_program
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
        login_create_process
        login_routine
        while @logged_in
            menu_prompt 
        end
    end

    def login_create_process
        user_response = player_name_prompt
        case 
        when user_response == "create" 
            create_player_name_prompt
            @logged_in = true
        when Player.find_by(name: user_response)
            @logged_in = true
            set_current_player(user_response)
        else
            puts "Not a valid player name, maybe create a new user 🤷 >"
            create_player_name_prompt
            @logged_in = true
        end
    end

    def login_routine
        check_current_team
    end

    def set_current_player(player_name)
        @current_player = Player.find_by(name: player_name)
    end

    def player_name_prompt
        prompt.ask("Enter your name to log in, or enter \"create\" to create a new player >")
    end

    def create_player_name_prompt
        user_response = prompt.ask("Enter your name >")
        if Player.find_by(name: user_response)
            puts "#{user_response} is already a user! Please try again."
            login_create_process
        else
            Player.create(name: user_response)
            set_current_player(user_response)
        end
    end

    def check_current_team
        @current_team = current_player.teams.find_by(last_team: true)
    end


    def menu_prompt
        menu_response = prompt.select("Menu >", ["Battle", "My Teams", "Leaderboard", "Log Out", "Exit"]) unless current_team
        menu_response = prompt.select("Your team is currently #{@pastel.red(current_team.name)} >", ["Battle", "My Teams", "Leaderboard", "Log Out", "Exit"]) if current_team
        case menu_response
        when "Battle" 
            battle_menu if current_team
            puts "You do not currently have a team! Please create one before battling again." unless current_team
        when "My Teams"
            my_teams_menu
        when "Leaderboard"
<<<<<<< HEAD
            #leaderboard function
        when "Log Out"
=======
            leaderboard_menu if Team.all.any?
            puts "There have been no battles! You need to battle first for there to be a leaderboard." unless Team.all.any?
        when "Logout"
>>>>>>> caa7d85a18307434c2811fd826b34efa2ab5838f
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
            puts "404 not found"
        end

<<<<<<< HEAD
        #Fighter.print_composite_image(current_team.drafts[0].fighter_id, current_team.drafts[1].fighter_id, current_team.drafts[2].fighter_id) if current_team.drafts.count == 3
=======
        current_team.print_composite if current_team.drafts.count == 3
>>>>>>> caa7d85a18307434c2811fd826b34efa2ab5838f
        create_team_menu unless current_team.drafts.count == 3
    end

    def my_teams_menu
<<<<<<< HEAD
        menu_response = prompt.select("Manage your teams >", ["Create a team", current_player_teams], "Delete", "Cancel"  ) if !current_team
        menu_response = prompt.select("Manage your teams >", ["Create a team", @pastel.red(current_team.name), current_player_teams_without_current_team ], "Delete", "Cancel"  ) if current_team
=======
        menu_response = prompt.select("Manage your Teams >", ["Create a team", current_player_teams], "Delete", "Cancel"  ) if !current_team
        menu_response = prompt.select("Manage your Teams >", ["Create a team", @pastel.blue(current_team.name), current_player_teams_without_current_team ], "Delete", "Cancel"  ) if current_team
>>>>>>> caa7d85a18307434c2811fd826b34efa2ab5838f
        if menu_response == "Create a team"
            puts "Your team will consist of three heroes/villains!"
            @current_team = Team.create(name: "")
            current_team.player = current_player
            create_team_menu
            current_team.set_team_name
            current_team.set_last_team
        elsif menu_response == "Delete"
            delete_menu
        elsif menu_response == "Cancel"
            #doing nothing returns to main menu
        else 
            @current_team = Team.find_by(name: @pastel.strip(menu_response))
            current_team.set_last_team
        end
    end

    def battle_menu
        menu_response = prompt.select("Choose a mode", ["Choose a player", "Random"])
        case menu_response
        when "Choose a player"
            battle_player_menu
        when "Random"
            random_opponent_id = (Player.player_ids_with_teams - [current_player.id]).sample
            opponent_team = Player.find(random_opponent_id).teams.sample
<<<<<<< HEAD
            winner_id = conduct_battle(current_team, opponent_team)
            winner = Team.find(winner_id)
            if winner == current_team
                puts "You've won! Congrats! 🎉🍾"
            else 
                puts "You were defeated. 😢 Better luck next time."
            end
=======
            puts "Your team is #{@pastel.green(current_team.name)}!"
            conduct_battle(current_team, opponent_team)
            # winner = Team.find(winner_id)
            # if winner == current_team
            #     puts "You have won! Congrats!"
            # else 
            #     puts "You were defeated. Better luck next time."
            # end
        end
    end

    def battle_player_menu
        menu_response = prompt.select("Choose a player", [Player.pluck(:name) - [current_player.name] ], "Cancel")
        @battle_player_instance = Player.find_by(name: menu_response)
        case menu_response
        when "Cancel"

        else
            player_menu(menu_response)     
        end
    end

    def player_menu(player_name)
        menu_response = prompt.select("Choose a team", [Player.find_by(name: player_name).teams.pluck(:name)], "Cancel")
        case menu_response
        when "Cancel"
        else 
            conduct_battle(current_team, Team.find_by(player: @battle_player_instance, name: menu_response))
>>>>>>> caa7d85a18307434c2811fd826b34efa2ab5838f
        end
    end

    def conduct_battle(team, opponent)
        battle = Battle.create(team: team, opponent: opponent)
        battlehash = battle.competition_hash

        test1 = battlehash.keys.sample
        announce_test_winner(battle, test1)

        test2 = (battlehash.keys - [test1]).sample
        announce_test_winner(battle, test2)

        test3 = (battlehash.keys - [test1, test2]).sample
        announce_test_winner(battle, test3)

        winner_id = battle.determine_winner(test1, test2, test3)
        winner = Team.find(winner_id)

        if winner == current_team
            puts @pastel.green("You have won! Congratulations!")
        else 
            puts @pastel.red("You were defeated. Better luck next time.")
        end

        winner
    end
        

    def announce_test_winner(battle, test)
        battlehash = battle.competition_hash
        battle_proclamation(test, battle.opponent)
        if battlehash[test]
            testwinner = battle.team 
            puts "#{@pastel.green(testwinner.name)} has won this test of #{test}!"
        else 
            testwinner = battle.opponent
            puts "#{@pastel.red(testwinner.name)} has won this test of #{test}!"
        end
        testwinner
    end
    
    def battle_proclamation(key, opp)
        puts "Your team of #{current_team.name} is facing #{opp.name} in a test of #{key}!"   
    end

    

    def delete_menu
        if current_player.teams.empty?
            puts "You have nothing to delete!"
            my_teams_menu
        elsif
            delete_team = prompt.select("Delete a team", [@pastel.red(current_team.name), current_player_teams_without_current_team, "Cancel"])
            if delete_team == "Cancel"
                my_teams_menu
            elsif delete_team == current_team.name 
                puts "You can't delete your currently selected team!"
                delete_menu
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
        menu_response = prompt.select("Choose a leaderboard", "Team", "Player", "Back")
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
        puts "\e[H\e[2J"
        puts "You have successfully logged out!"
        start_program
    end

    def goodbye
<<<<<<< HEAD
        puts "Sad to see you go! Goodbye! 👋✌️"
=======
        puts "\e[H\e[2J"
        puts "Sad to see you go! Goodbye!"
>>>>>>> caa7d85a18307434c2811fd826b34efa2ab5838f
        @logged_in = false
    end

end