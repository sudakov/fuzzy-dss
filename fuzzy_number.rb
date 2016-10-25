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
        return (a * x + b).round(5)
      end
    end
    puts "error #{x}"
  end
  def get_scale
    @polyline.map{|x|x[0]}
  end
  
  def get_polyline
    @polyline
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
    scale = (scale + scale_add).uniq.sort
    scale.map!{|s| s.round(5)}
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
  
  # draft 
  def general_operation(n1,n2,operation)
    scale = prep_scale(n1,n2)
    a = n1.get_scale[0]
    b = n1.get_scale[-1]
    pp = []
    scale.each do |x1|
      scale.each do |x2|
        x = case operation
              when '*' then x1*x2
              when '+' then x1+x2
              when '-' then x1-x2
              when '/' then x1/x2
            end
        x = x.round(5)
        pp << [x, [n1.get_membership(x1),n2.get_membership(x2)].min]
        next if (operation == '/' and x == 0)
        a.step(b,((b-a)/1000.0).round(5)) do |s1|
          next if (operation == '*' and s1 == 0)
          s2 = case operation
              when '*' then x / s1
              when '+' then x - s1
              when '-' then s1 - x       
              when '/' then s1 / x   
            end
          pp << [x, [n1.get_membership(s1),n2.get_membership(s2)].min]
        end
      end
    end
    scale = pp.collect{|p| p[0]}.uniq.sort
    FuzzyNumber.new(scale.collect{|s| [s, pp.select{|x| x[0]==s}.collect{|x| x[1]}.max] })
  end
  
  def *(other)
    general_operation(self,other,'*')
  end
  def +(other)
    general_operation(self,other,'+')
  end
  def -(other)
    general_operation(self,other,'-')
  end
  def /(other)
    general_operation(self,other,'/')
  end
  
  def to_s
    @polyline.collect{|x| x[0]}.join("\t") + "\n" +
    @polyline.collect{|x| x[1]}.join("\t")
  end
end
