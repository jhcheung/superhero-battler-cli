class Fighter < ActiveRecord::Base
    has_many :drafts
    has_many :teams, through: :drafts

    def superhero_image_dir
        File.exist?("./imgs/#{id}.jpg") ? "./imgs/#{self.id}.jpg" : "./imgs/placeholder_both.jpg"
    end

    def print_fighter_image
        Catpix.print_image(superhero_image_dir, {limit_x: 0.50, limit_y: 0.50, resolution: "high"})
    end

    def self.print_composite_image(f1, f2, f3)
        # image_list = Magick::ImageList.new("./imgs/#{id1}.jpg", "./imgs/#{id2}.jpg", "./imgs/#{id3}.jpg")
        # image_list = image_list.montage do
        #     |image| image.tile="1x3", image.background_color = "black", self.geometry = "130x194+10+5"
        # end
        # image_list.write("./imgs/#{id1}_#{id2}_#{id3}.png")
        # Catpix.print_image("./imgs/#{id1}_#{id2}_#{id3}.png", {limit_x: 0.90, limit_y: 0.90, resolution: "high"})
        image_list = Magick::ImageList.new(f1.superhero_image_dir, f2.superhero_image_dir, f3.superhero_image_dir)
        image_list = image_list.montage do
            |image| image.tile="1x3", image.background_color = "black", self.geometry = "130x194+10+5"
        end
        image_list.write("./imgs/#{f1.id}_#{f2.id}_#{f3.id}.png")
        Catpix.print_image("./imgs/#{f1.id}_#{f2.id}_#{f3.id}.png", {limit_x: 0.90, limit_y: 0.90, resolution: "high"})
    end

    def drafts
        Draft.select { |draft| draft.fighter == self }
    end

    def team_ids
        drafts.map { |draft| draft.team.id }
    end

    def wins_count
        # Battle.includes(team: [:fighters]).select do |battle| 
        #     team_ids.include?(battle.winner_id) 
        # end
        teams.sum(&:wins_count)
    end

    def self.fighters_with_wins

            Battle.wins_find_by_fighter()
    end

end