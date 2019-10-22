class Fighter < ActiveRecord::Base
    has_many :drafts
    has_many :teams, through: :drafts

    def superhero_image_dir
        "./imgs/#{self.id}"
    end

    def print_fighter_image
        Catpix.print_image("./imgs/#{self.id}.jpg", {limit_x: 1, limit_y: 1, resolution: "high"})
    end

    def self.print_composite_image(id1, id2, id3)
        image_list = Magick::ImageList.new("./imgs/#{id1}.jpg", "./imgs/#{id2}.jpg", "./imgs/#{id3}.jpg")
        image_list = image_list.montage do
            |image| image.tile="1x3", image.background_color = "black", self.geometry = "130x194+10+5"
        end
        image_list.write("./imgs/#{id1}_#{id2}_#{id3}.png")
        Catpix.print_image("./imgs/#{id1}_#{id2}_#{id3}.png", {limit_x: 0.90, limit_y: 0.90, resolution: "high"})
    end

end