require "rest-client"
require_relative '../secretkey.rb'
require_relative '../config/environment.rb'
require 'json'
require 'pry'




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

# [*1..731].each do |number|
#    create_superhero_by_id(number)
# end