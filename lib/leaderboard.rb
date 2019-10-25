class Leaderboard

    attr_reader :table

    # make instance methods in player/team/etc to better refactor


    def construct_team_leaderboard
        @table = TTY::Table.new header: ["Rank", "Team", "Wins"]
        table_array = []
        Team.all.each do |team|
            team.reload
            table_array << [ team.name, team.overall_wins_count]
        end
        table_array = order_table_and_delete_zeroes(table_array)
        make_table_with_ranks(table_array)
        table
    end

    def construct_player_leaderboard
        @table = TTY::Table.new header: ["Rank", "Player", "Wins"]
        table_array = []
        Player.all.each do |player|
            player.reload
            table_array << [ player.name, player.wins_count]
        end
        table_array = order_table_and_delete_zeroes(table_array)
        make_table_with_ranks(table_array)
        table
    end

    def construct_fighter_leaderboard
        @table = TTY::Table.new header: ["Rank", "Fighter", "Wins"]
        table_array = []
        Team.fighters_from_teams_with_wins.each do |fighter|
            fighter.reload
            table_array << [ fighter.name, fighter.wins_count]
        end
        table_array = order_table_and_delete_zeroes(table_array)
        make_table_with_ranks(table_array)
        table
    end

    def order_table_and_delete_zeroes(table_array)
        table_array = table_array.sort_by { |row| row[1] }.reverse
        table_array = table_array.select { |row| row[1] > 0 }
    end

    def make_table_with_ranks(table_array)
        table_array.each_with_index do |row, index|
            table << [ index + 1, row ].flatten
        end
    end

    def render_table(method)
        send(method).render(:unicode, alignment: [:center])
    end

end