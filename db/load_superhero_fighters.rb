require "rest-client"
require_relative '../secretkey.rb'
require_relative '../config/environment.rb'
require 'json'
require 'pry'
require 'down'
require 'fileutils'



def superhero_hash_by_id(id)
    sh = RestClient.get("https://superheroapi.com/api/#{MyKey.new.superhero_key}/#{id}/powerstats")
    sh_hash = JSON.parse(sh)
end

def create_superhero_by_id(id)
    sh_hash = superhero_hash_by_id(id)
    sh_hash.delete("error")
    sh_hash.delete("response")
    sh_hash.delete("id")
    Fighter.create(sh_hash)
end

def superhero_image_by_id(id)
    sh = RestClient.get("https://superheroapi.com/api/#{MyKey.new.superhero_key}/#{id}/image")
    sh_image_hash = JSON.parse(sh)
end

def download_images_by_id(id, number)
    sh_image_hash = superhero_image_by_id(id)
    tempfile = Down.download(sh_image_hash["url"]) 
    FileUtils.mv(tempfile.path, "./imgs/#{number}.jpg")
end

# [*1..731].each do |number|
#     begin
#         download_images_by_id(number, number)
#     rescue
#         puts "missing #{number}"
#     end         
# end

# [*1..731].each do |number|
#    create_superhero_by_id(number)
# end

# [51, 54, 74, 101, 113, 117, 124, 131, 133, 134, 143, 164, 184, 205, 244, 283, 288, 290, 291, 292, 362, 447, 453, 511, 512, 552, 553, 593, 603, 629, 662, 682, 694, 698, 715, 721, 725]

