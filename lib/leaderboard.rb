class Leaderboard

    # def self.teams_leaderboard_array
    #     Team.execute_sql("SELECT teams.name, COUNT(*) FROM teams JOIN battles ON winner_id = teams.id GROUP BY teams.name")
    # end

    attr_accessor :class, :being_ranked, :count


    def construct_team_leaderboard
        @being_ranked = "Team"
        @table = TTY::Table.new header: ["Rank", being_ranked, count]
        Team.all.each_with_index do |team, index|
            count = Battle.where(winner_id: team.id).count
            @table << [index + 1, team.name, count]
        end
        @table
    end


    def check_counts(team, attribute, id)
        Team.where(attribute: id).count
    end




end