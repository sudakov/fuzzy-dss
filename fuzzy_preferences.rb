# The reported study was funded by RFBR according to the research project No 16-01-00571 A
require_relative 'fuzzy_number'
require 'json'

file = %{
{
  "criterions" : [
    {
      "name": "crit1",
      "scale": [
        0,
        0.2,
        0.6,
        0.6,
        1
      ]
    },
    {
      "name": "crit2",
      "scale": [1,2,3,4]
    },
    {
      "name": "crit3",
      "scale": ["green","red"]
    },
    {
      "name": "generalized criterion",
      "scale": ["good","bad"]
    }  
  ],
  "aggregation": [
    {
      "input": [0,1,2],
      "output": 3,
      "rules": [
        { "conditions": [[0,0],[1,0],[2,1]],
          "result": 0
        },
        { "conditions": [[0,1],[1,1],[2,1]],
          "result": 2
        }
      ] 
    }
  ]
}
}
h = JSON.parse(file)

p h
