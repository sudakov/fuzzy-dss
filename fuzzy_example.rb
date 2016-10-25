require_relative 'fuzzy_number'

num1 = FuzzyNumber.new([[1,0],[2,1],[3,0]]) # Triangular membership function
num2 = FuzzyNumber.new([[2,0],[3,1],[4,0]])  

puts num1.get_membership(0.84)
puts num1 == num2
puts num1 >= num2
puts num1 <= num2

num3 = FuzzyNumber.new([[1,0],[4.5,1],[5,1],[7,0]]) #Trapezoid membership function
puts num1 >= num3

# draft
p num1 * num2
