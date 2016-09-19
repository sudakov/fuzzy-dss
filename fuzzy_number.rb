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
  def get_membership(x)
    last_index = @polyline.size-1
    @polyline.each_with_index do |point,i|
      if (x == point[0]) or (i==0 and x < point[0]) or (i==last_index and x > point[0])
        return point[1]
      elsif x.between?(point[0],@polyline[i+1][0])
        a = (@polyline[i+1][1]-point[1])/(@polyline[i+1][0]-point[0])
        b = point[1] - a * point[0]
        return a * x + b
      end
    end
  end
  def get_scale
    @polyline.map{|x|x[0]}
  end
  
  def ==(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    return 1.0 - scale.map{|x| (self.get_membership(x) - other.get_membership(x)).abs }.max
  end
  
  def >=(other)
    
  end
end

# my_num1 = FuzzyNumber.new([[1,0],[2,1],[3,1],[4,0]])
# my_num2 = FuzzyNumber.new([[0.4,0],[2.5,1],[4.6,0]])
# puts my_num1 == my_num2
