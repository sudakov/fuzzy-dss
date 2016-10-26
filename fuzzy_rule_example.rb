require_relative 'fuzzy_number'
# Example from book Fuzzy Systems Theory and Its Applications. Toshiro Terano, Kiyoji Asai, Michio Sugeno

# rule: if the water level is high then open the valve
# water level = quite high
# consequence: open valve slightly

high_water_level = FuzzyNumber.new([[0.0,0.0],[1.5,0.1],[1.6,0.3],[1.7,0.7],[1.8,0.8],[1.9,0.9],[2.0,1.0],[2.1,1.0],[2.2,1.0]])
open_valve = FuzzyNumber.new([[0,0.0],[30,0.1],[40,0.2],[50,0.3],[60,0.5],[70,0.8],[80,1.0],[90,1.0]])
quite_high_water_level = FuzzyNumber.new([[1.5,0.0],[1.6,0.5],[1.7,1.0],[1.8,0.8],[1.9,0.2],[2.0,0.0]])

a = high_water_level & quite_high_water_level
puts a

puts (high_water_level | quite_high_water_level)

rule_strength = a.get_max_membership
puts rule_strength

consequence = open_valve.clip_membership(rule_strength)

puts consequence

# must be 70
puts consequence.defuzzification

