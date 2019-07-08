require_relative 'fuzzy_number'

# You must pass membership function into constructor as polyline: [[x1, mu(x1)],[x2, mu(x2)]....]

num1 = FuzzyNumber.new([[20.0,0.0],[27,0.6],[40,1.0]]) # Triangular membership function
num2 = FuzzyNumber.new([[15.0,0.0],[20.0,0.3],[24,0.8],[33,1.0]])



puts num1 + num2
