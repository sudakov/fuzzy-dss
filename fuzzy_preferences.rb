# The reported study was funded by RFBR according to the research project No 16-01-00571 A
require_relative 'fuzzy_number'
require_relative 'fuzzy_set'
require 'json'

file = %{
{
  "fuzzy_sets": [
    {
        "name": "about 1",
        "polyline": [[0,0],[1,1],[2.5,0]]
    },
    {
        "name": "about 2",
        "polyline": [[0.5,0],[2,1],[3.5,0]]
    },
    {
        "name": "big num",
        "polyline": [[2,0],[10,1]]
    },
    {
        "name": "from 1 to 3",
        "polyline": [[0.99,0],[1,1],[3,1],[3.01,0]]
    },
    {
        "name": "good",
        "polyline": [[3,0],[5,1]]
    },
    {
        "name": "bad",
        "polyline": [[0,0],[1,1],[2,1],[4,0]]
    },
    {
      "name": "red",
      "membership": [["red",1]]
    },
    {
      "name": "green",
      "membership": [["green",1]]
    }
  ],
  "criterions" : [
    {
      "name": "crit1",
      "scale": ["about 1", "about 2", "big num"]
    },
    {
      "name": "crit2",
      "scale": ["about 1","from 1 to 3"]
    },
    {
      "name": "crit3",
      "scale": ["green","red"]
    },
    {
      "name": "generalized criterion",
      "scale": ["bad","good"],
      "rules": [
        { "conditions": {"crit1": "about 1", "crit2": "about 1", "crit3":["green","red"] },
          "result": "bad"
        },
        { "conditions": {"crit1": "about 2", "crit2": "from 1 to 3", "crit3":"red" },
          "result": "good"
        }
      ]
    }
  ],
  "alternatives" : [
    {"crit1": 1.5, "crit2": 0.1, "crit3": "green"},
    {"crit1": 2,   "crit2": 2,   "crit3": "red"},
    {"crit1": 1,   "crit2": 1,   "crit3": "red"}
  ]
}
}
h = JSON.parse(file)

p h

def get_fuzzy_value(h,v)
  fuzzy_value = nil    
  if v.is_a? Numeric
    fuzzy_value = FuzzyNumber.new([[v-0.0001,0],[v,1],[v+0.0001,0]]) 
  elsif v.is_a? String
    fuzzy = h["fuzzy_sets"].find{|f| f["name"]==v}
    raise "Can not find valid fuzzy value  #{v}" if fuzzy.nil?
    if fuzzy["polyline"] 
      fuzzy_value = FuzzyNumber.new(fuzzy["polyline"])
    elsif fuzzy["membership"]
      fuzzy_value = FuzzySet.new(fuzzy["membership"])
    else
      raise "Fuzzy value #{v} not valid"
    end
  else
    raise "Can not find fuzzy value #{v}"
  end
  return fuzzy_value
end

h["alternatives"].each do |a|
  total_res = nil
  h["criterions"][3]["rules"].each do |r|
    rule_strength = 1.0
    #puts "rule = "
    #p r
    r["conditions"].each do |crit,condition|
      fuzzy_value = get_fuzzy_value(h,a[crit])
      if not condition.is_a? Array
        condition=[condition]
      end
      cc = nil
      condition.each do |cond|  
        fuzzy_cond  = get_fuzzy_value(h,cond) 
        c = fuzzy_value & fuzzy_cond
        if cc.nil?
            cc = c
        else
            cc = cc | c
        end
        # puts "c=#{c}"
      end
      rule_strength = [rule_strength, cc.get_max_membership].min
      #puts "rule_strength = #{rule_strength}"
    end
    rule_res = get_fuzzy_value(h,r["result"]).clip_membership(rule_strength)
    #puts "rule_res = #{rule_res}"
    if total_res.nil?
      total_res = rule_res
    else
      total_res = total_res | rule_res
    end
  end
  puts "a="
  p a
  puts "total_res = #{total_res}"
  res = total_res.defuzzification
  puts "#{res}"
end

