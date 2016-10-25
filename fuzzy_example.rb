require_relative 'fuzzy_number'

num1 = FuzzyNumber.new([[0.48,0],[0.92,1],[1.32,0]]) # Triangular membership function
num2 = FuzzyNumber.new([[0.32,0],[0.76,1],[1.2,0]])  

puts num1.get_membership(0.84)
puts num1 == num2
puts num1 >= num2
puts num1 <= num2

num3 = FuzzyNumber.new([[1,0],[4.5,1],[5,1],[7,0]]) #Trapezoid membership function
puts num1 >= num3 
