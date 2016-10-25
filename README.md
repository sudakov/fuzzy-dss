# fuzzy-dss
Fuzzy sets, numbers, rules, logic for decision support systems

```ruby
require_relative 'fuzzy_number'

# You must pass membership function into constructor as polyline: [[x1, mu(x1)],[x2, mu(x2)]....]

num1 = FuzzyNumber.new([[1,0],[2,1],[3.1,0]]) # Triangular membership function
num2 = FuzzyNumber.new([[1.7,0],[3,1],[4,0]])

puts num1.get_membership(1.5)
puts num1 == num2
puts num1 >= num2
puts num1 <= num2

num3 = FuzzyNumber.new([[1,0],[4.5,1],[5,1],[7,0]]) #Trapezoid membership function
puts num1 >= num3

puts num1 * num2
puts num1 + num2
puts num1 - num2
puts num1 / num2
```
