class Leaderboard

    # def self.teams_leaderboard_array
    #     Team.execute_sql("SELECT teams.name, COUNT(*) FROM teams JOIN battles ON winner_id = teams.id GROUP BY teams.name")
    # end


    def construct_team_leaderboard
        @table = TTY::Table.new header: ["Rank", "Team", "Wins"]
        table_array = []
        Team.all.each do |team|
            count = Battle.where(winner_id: team.id).count
            table_array << [ team.name, count]
        end
        table_array = table_array.sort_by { |row| row[1] }.reverse
        
        table_array.each_with_index do |row, index|
            @table << [ index + 1, row ].flatten
        end
        @table
    end

    def construct_player_leaderboard
        @table = TTY::Table.new header: ["Rank", "Player", "Wins"]
        table_array = []
        Player.all.each do |player|
            wins = Battle.player_battles_won_team_ids.select do |teamid| 
                player.team_ids.include?(teamid)
            end 
            table_array << [ player.name, wins.count]
        end
        table_array = table_array.sort_by { |row| row[1] }.reverse
        table_array = table_array.select { |row| row[1] > 0 }

        table_array.each_with_index do |row, index|
            @table << [ index + 1, row ].flatten
        end
        @table
    end

    def render_table(method)
        send(method).render(:unicode, alignment: [:center])
    end

end