Superhero Battler CLI by Jimmy & Nick
========================

Superhero Battler is a CLI application inspired by autobattler genre games, such as Teamfight Tactics, Auto Chess, and Dota Underlords. In Superhero Battler, players will create a team consisting of three superheroes/supervillains and battle with other players' teams to determine who has the best superhero team!

Superhero Battler uses the Superhero API for powerstats and images:  
https://superheroapi.com  
https://github.com/akabab/superhero-api

Notable gems used:  
[TTY/Pastel](https://ttytoolkit.org/) (especially TTY-prompt) for the fancy user interface  
[Catpix](https://github.com/pazdera/catpix) for printing superhero images in the terminal  
[RMagick/ImageMagick](https://github.com/rmagick/rmagick) for montaging superhero images and displaying them  
ActiveRecord/Sinatra/SQLite for the OO relationship DB magic  

---

## How to Install

1. Use Bundler to install the required gems.
```
bundle install
```
2. Run the following rake tasks to set up the databases and seed the fighters database with superhero data scraped from Superhero-API.
```
rake db:environment:set
rake db:migrate
rake db:seed
```
3. This repo does not include superhero images. If you wish to include superhero images, you can run the scraper in "load_superhero_fighters.rb" to download the images yourself. You will need to visit Superhero API to register an access token and replace the ```MyKey.new.superhero_key``` variable with your access token. Please note that some images are missing, as the links in Superhero API provides for those heroes are dead. 
```ruby
[*1..731].each do |number|
    begin
         download_images_by_id(number, number)
     rescue
         puts "missing #{number}"
     end         
 end
```
4. Run bin/run.rb and you'll be able to play! 
```
ruby bin/run.rb
```
---
## How to Play

- First, you can create a new user using the **create** command or login to an existing user by typing a username. You will then be brought to the main menu, which will have several options.
- In the **Battle** menu, you can start a **Random battle** with other teams or **Battle a player**. Two teams have already been seeded for you to battle. However, in order to battle, you must first...
- **Create a team** in the **My Teams** menu. To **Create a team**, you will type in the names of three superheroes/villains to add to your team. After creating a team, you can also **Delete** a team or switch to another team to battle.
- The **Leaderboard** menu contains three leaderboards: **Team**, **Player**, and **Fighter**. After several battles, you can see the results of your battles here!
- In the **My Account** menu, you can change the name of your account or delete your account. This will delete your rankings from the leaderboard!
- Finally, you can **Log Out** or **Exit** out of the application.

---
## Images
![Title Screen](./screenshots/title-screen.png)

![Main Menu](./screenshots/main-menu.png)

![Team Creation](./screenshots/team-creation.png)

![Team Battle](./screenshots/team-battle.png)

![Leaderboards](./screenshots/leaderboard.png)

