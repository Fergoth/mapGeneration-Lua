settings = {
  fillprob = 25,
  iterations = {
    {
      count = 4,
      r1_cutoff = 5,
      r2_cutoff = 2
    },
    {
      count = 3,
      r1_cutoff = 5,
      r2_cutoff = 0
    }
  },
  size_x = 25,
  size_y = 25
}
local map =  require "generate_map"
map1 = map:new()
map2 = map:new()
map1:generate(settings)
map2:generate(settings)
map1:print()
map2:print()
