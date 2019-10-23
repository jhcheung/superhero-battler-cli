require_relative '../config/environment'

# fighter1 = Fighter.all[643]
# fighter2 = Fighter.all[619]
# fighter3 = Fighter.all[719]

# binding.pry
# Fighter.print_composite_image(fighter1, fighter2,fighter3)
# Fighter.print_composite_image(620,644,442)
cli = CLI.new
cli.greet
cli.start_program
