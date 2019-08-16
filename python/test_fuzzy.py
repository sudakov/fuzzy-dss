import fuzzy_number as fz

num1 = fz.FuzzyNumber([[1,0],[2,1],[3.1,0]])
num2 = fz.FuzzyNumber([[1.7,0],[3,1],[4,0]])

print(num1.get_membership(1.5))

print(num1 == num2)

print(num1 >= num2)

print(num1 <= num2)

print(num1 * num2)
print(num1 + num2)
print(num1 - num2)
print(num1 / num2)
