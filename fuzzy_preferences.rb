# The reported study was funded by RFBR according to the research project No 16-01-00571 A
require_relative 'fuzzy_number'
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
        { "conditions": {"crit1": "about 2", "crit2": "from 1 to 3", "crit3":["red"] },
          "result": "good"
        }
      ]
    }
  ],
  "alternatives" : [
    {"crit1": 1.5, "crit2": 0.1, "crit3": "green"},
    {"crit1": 4,   "crit2": 4,   "crit3": "red"},
    {"crit1": 1,   "crit2": 1,   "crit3": "green"}
  ]
}
}
h = JSON.parse(file)

p h
