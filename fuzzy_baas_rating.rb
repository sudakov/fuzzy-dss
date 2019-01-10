require_relative 'fuzzy_number'

good = FuzzyNumber.new([[0.6,0.0],[0.8,1.0],[1.0,0.0]])
fair = FuzzyNumber.new([[0.4,0.0],[0.6,1.0],[0.8,0.0]])

very_important     = FuzzyNumber.new([[0.8,0.0],[1.0,1.0]])
rather_unimportant = FuzzyNumber.new([[0.0,0.0],[0.2,1.0],[0.4,0.0]])

alternative_1 = very_important * good + rather_unimportant * fair
puts "alternative_1"
puts alternative_1

alternative_2 = very_important * fair + rather_unimportant * good
puts "alternative_2"
puts alternative_2

puts "alternative_1>=alternative_2"
puts alternative_1>=alternative_2

puts "alternative_2>=alternative_1"
puts alternative_2>=alternative_1
