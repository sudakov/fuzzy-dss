import fuzzy_number
       
num1 = FuzzyNumber([[1,0],[2,1],[3.1,0]])
num2 = FuzzyNumber([[1.7,0],[3,1],[4,0]])

print(num1.get_membership(1.5))
