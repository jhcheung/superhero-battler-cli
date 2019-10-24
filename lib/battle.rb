class Battle < ActiveRecord::Base
    belongs_to :team
    belongs_to :opponent, class_name: 'Team'
    after_initialize :three_random_tests

    attr_reader :tests

    def competition_hash
        {
            intelligence: attribute_win?(:intelligence),
            wordiness: longest_team_name,
            randomness: random_fighter_win?,
            strength: attribute_win?(:strength),
            speed: attribute_win?(:speed),
            durability: attribute_win?(:durability),
            power: attribute_win?(:power),
            experience: attribute_win?(:combat)
        }
    end

    # def determine_winner(testarray)
    #     results = testarray.map { |test| competition_hash[test] }

    #     # test_results = { test1 => nil, test2 => nil, test3 => nil }
    #     # test_results = test_results.reduce({}) do |new_hash, (key, value)|
    #     #     new_hash[key] = self.competition_hash[key]
    #     #     new_hash
    #     # end
    #     results.count(true) > testarray.count(false) ? self.winner_id = team.id : self.winner_id = opponent.id
    #     self.save
    #     testarray
    # end

    def determine_winner
        test_results.values.count(true) > test_results.values.count(false) ? self.winner_id = team.id : self.winner_id = opponent.id
        self.save
        test_results
    end

    def three_random_tests
        @tests = competition_hash.keys.sample(3)
    end

    def test_results
        tests.reduce({}) do |new_hash, test| 
            new_hash[test] = competition_hash[test] 
            new_hash 
        end
    end

    def attribute_win?(attribute)
        sum = team.fighters.sum(&attribute)
        opp_sum = opponent.fighters.sum(&attribute)
        sum >= opp_sum ? true : false
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

    def self.player_battles_won
        self.all.select { |battle| battle.team_id == battle.winner_id }
    end

    def self.player_battles_won_team_ids
        player_battles_won.map { |battle| battle.team_id }
    end



end

