class Battle < ActiveRecord::Base
    belongs_to :team
    belongs_to :opponent, class_name: 'Team'

    def determine_winner(test1, test2, test3)
        test_results = { test1 => nil, test2 => nil, test3 => nil }
        test_results = test_results.reduce({}) do |new_hash, (key, value)|
            new_hash[key] = self.competition_hash[key]
            new_hash
        end
        test_results.values.count(true) > test_results.values.count(false) ? self.winner_id = team.id : self.winner_id = opponent.id
        self.save
        test_results
    end

    def competition_hash
        {
            intelligence: intelligence_win?,
            wordiness: longest_team_name,
            randomness: random_fighter_win?,
            strength: strength_win?,
            speed: speed_win?,
            durability: durability_win?,
            power: power_win?,
            experience: combat_win?,
        }
    end

    def intelligence_win?
        int = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:intelligence]}
        opp_int = opponent.fighters.sum(&:intelligence)
        int >= opp_int ? true : false
    end

    def longest_team_name
        player_name_length = team.name.size
        opponent_name_length = opponent.name.size
        player_name_length >= opponent_name_length ? true : false
    end

    def random_fighter_win?
        team_fighter = rand(1..100)
        opponent_fighter = rand(1..100)
        team_fighter >= opponent_fighter ? true : false
    end

    def durability_win?
        dura = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:durability]}
        opp_dura = opponent.fighters.sum(&:durability)
        dura >= opp_dura ? true : false
    end

    def speed_win?
        speed = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:speed]}
        opp_speed = opponent.fighters.sum(&:speed)
        speed >= opp_speed ? true : false
    end

    def power_win?
        pow = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:power]}
        opp_pow = opponent.fighters.sum(&:power)
        pow >= opp_pow ? true : false
    end

    def strength_win?
        str = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:strength]}
        opp_str = opponent.fighters.sum(&:strength)
        str >= opp_str ? true : false
    end

    def combat_win?
        com = team.fighters.reduce(0) { |sum, fighter| sum + fighter[:combat]}
        opp_com = opponent.fighters.sum(&:combat)
        com >= opp_com ? true : false
    end

    def self.player_battles_won
        self.all.select { |battle| battle.team_id == battle.winner_id }
    end

    def self.player_battles_won_team_ids
        player_battles_won.map { |battle| battle.team_id }
    end



end

