class CLI
    def greet 
        puts "Welcome to Jimmy and Nick's Superhero Battle App!"
    end

    def start_program
        puts "Enter your name to log in, or enter \"create\" to create a new player > "
        user_input = gets.chomp
        if user_input == "create" 
            puts "Enter your name >"
            Player.create(name: user_input)
            show_teams_prompt
        elsif Player.find_by(name: user_input)
            menu_prompt
        else
            puts "Not a valid player name, create new user >"
            create_player
        end
    end

    # def show_teams_prompt
    #     teams = Team.all.map {|team| team.name}
    #     prompt = TTY::Prompt.new
    #     prompt.select("Choose your team >", [teams.each {|names| puts names}])
    # end

    def menu_prompt
        teams = Team.all.map {|team| team.name}
        prompt = TTY::Prompt.new
        prompt.select("Menu >", ["Battle", "My Teams", "Leaderboard", "Exit"])
        case prompt
        when "Battle" 
            #battle function
        when "My Teams"
            #my_teams function
        when "Leaderboard"
            #leaderboard function
        when "Exit"
            #exit function
        end
    end

end