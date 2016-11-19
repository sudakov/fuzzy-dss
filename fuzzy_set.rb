class FuzzySet
  
  def initialize(membership)
    @membership = membership
    @membership.each do |point|
      point[1]=point[1].to_f
      if @membership.count{|x| point[0] == x[0]} > 1
        raise "Not valid fuzzy membership at #{point[0]}"
      end
    end
  end
  
  def get_membership(x)
    point = @membership.find{|p| p[0]==x}
    if point
        return point[1]
    else
        return 0
    end
  end
  
  def get_scale
    @membership.map{|x|x[0]}
  end
  
  def get_mu
    @membership
  end
  
  def ==(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    return 1.0 - scale.map{|x| (self.get_membership(x) - other.get_membership(x)).abs }.max
  end
  
  def >=(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
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
     
  def to_s
    @membership.collect{|x| x[0]}.join("\t") + "\n" +
    @membership.collect{|x| x[1]}.join("\t")
  end
  
  def clip_membership( a )
    FuzzySet.new(@membership.map{|x| [x[0],[a,x[1]].min]})
  end
  
  def get_max_membership
    @membership.map{|x| x[1]}.max
  end
  
  def &(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    membership = scale.map{|x|[x,[self.get_membership(x),other.get_membership(x)].min]}
    FuzzySet.new(membership)
  end
  
  def |(other)
    scale = (self.get_scale + other.get_scale).uniq.sort
    membership = scale.map{|x|[x,[self.get_membership(x),other.get_membership(x)].max]}
    FuzzySet.new(membership)    
  end
  
end
