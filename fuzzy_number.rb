# Класс нечетких чисел
class FuzzyNumber
  
  def initialize(polyline)
    @polyline = polyline
    @polyline.each_with_index do |point,i|
      point[0]=point[0].to_f
      point[1]=point[1].to_f
      if i > 0 and point[0] == @polyline[i-1][0]
        raise "Not valid fuzzy membership polyline"
      end
    end
  end
  
  def get_line( point1, point2 )
    a = (point2[1]-point1[1])/(point2[0]-point1[0])
    b = point1[1] - a * point1[0]
    return a,b
  end

  def get_membership(x)
    last_index = @polyline.size-1
    @polyline.each_with_index do |point,i|
      if (x == point[0]) or (i==0 and x < point[0]) or (i==last_index and x > point[0])
        return point[1]
      elsif x.between?(point[0],@polyline[i+1][0])
        a,b = get_line( point, @polyline[i+1])
        return a * x + b
      end
    end
  end
  def get_scale
    @polyline.map{|x|x[0]}
  end
  
  def prep_scale( *numbers )
    
    scale = ( numbers.inject([]){ |sum, s| sum + s.get_scale } ).uniq.sort
    starting_line = []
    ending_line = []
    started_line = []
    scale.each do |x|
=begin
      starting_line = []
      numbers.each_with_index do |number, i|
        j = number.get_scale.index(x)  
        if j
          starting_line << [i,j,number.get_membership(x)]
          ending_line << [i,j,number.get_membership(x)] if started_line.index{|x| x[]}
        end
      end
      started_line = starting_line.clone
=end
    end
  end
  
  def ==(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    return 1.0 - scale.map{|x| (self.get_membership(x) - other.get_membership(x)).abs }.max
  end
  
  def >=(other)
    prep_scale(self,other)
    0.5
  end
end

my_num1 = FuzzyNumber.new([[1,0],[2,1],[3,1],[4,0]])
my_num2 = FuzzyNumber.new([[0.5,0],[2.5,1],[4.5,0]])

puts my_num1.get_membership(1.5)
puts my_num1 == my_num2
puts my_num1 >= my_num2
