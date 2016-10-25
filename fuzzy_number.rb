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
    n = numbers.size 
    scale = ( numbers.inject([]){ |sum, s| sum + s.get_scale } ).uniq.sort
    ys = nil
    old_ys = nil
    old_x = nil
    scale_add = []
    scale.each do |x|
        ys=numbers.collect{ |num| num.get_membership(x) }
        if old_ys
          for i1 in (0...n)
            for i2 in ((i1+1)...n)
                if (old_ys[i1]>old_ys[i2] and ys[i1]<ys[i2]) or
                   (old_ys[i1]<old_ys[i2] and ys[i1]>ys[i2])
                  a1,b1 = get_line( [old_x,old_ys[i1]], [x,ys[i1]] )
                  a2,b2 = get_line( [old_x,old_ys[i2]], [x,ys[i2]] )
                  scale_add <<  (b2-b1) / (a1-a2)
                end
            end
          end
        end
        old_x = x
        old_ys = ys
    end
    (scale + scale_add).uniq.sort
  end
  
  def ==(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    return 1.0 - scale.map{|x| (self.get_membership(x) - other.get_membership(x)).abs }.max
  end
  
  def >=(other)
    scale = prep_scale(self,other)
    mu = []
    scale.each do |x1|
      scale.each do |x2|
        mu << [self.get_membership(x1),other.get_membership(x2)].min if x1>=x2
      end
    end
    mu.max
  end
  
  def <=(other)
    other>=self
  end
end
