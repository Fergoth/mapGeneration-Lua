
local map = {
  floor = "0",
  wall = "1"
}

function map:new()
  newObj = {}
  self.__index = self
  return setmetatable(newObj,self)
end

function map:generate(settings)
  local grid = {}
  local grid2 = {}
  self.x = settings.size_x
  self.y = settings.size_y
  local fillprob = settings.fillprob

  local function randpick()
    if math.random(100) < fillprob then return self.wall else return self.floor end
  end

  local function initmap()
    math.randomseed(os.time())
    for i = 1, self.x do
      grid[i] = {}
      for j = 1, self.y do
        grid[i][j] = randpick()
      end
    end
    for i = 1, self.x do
      grid2[i] = {}
      for j = 1, self.y do
        grid2[i][j] = self.wall
      end
    end
    for xi = 1, self.x do
      grid[xi][1],grid[xi][self.y] = self.wall,self.wall
    end
    for yi = 1, self.y do
      grid[1][yi],grid[self.x][yi] = self.wall,self.wall
    end
  end

  local function generation(r1_cutof,r2_cutof)
    for i = 2, self.x-1 do
      for j = 2, self.y-1 do
        adjcout_r1, adjcount_r2 = 0,0
        for ii = -1, 1 do
          for jj = -1, 1 do
            if grid[i+ii][j+jj] == self.wall then adjcout_r1 = adjcout_r1+1 end
          end
        end

        for ii = i-2, i+2 do
          for jj =j-2, j+2 do
            if not ((math.abs(ii-i) == 2 and math.abs(jj-j) == 2) or (ii<1 or jj<1 or ii>self.x or jj>self.y )) then
              if grid[ii][jj] == self.wall then adjcount_r2 = adjcount_r2 + 1 end
            end
          end
        end

        if adjcout_r1 >= r1_cutof or adjcount_r2<=r2_cutof then
          grid2[i][j] = self.wall
        else
          grid2[i][j] = self.floor
        end
      end
    end
    for i = 2, self.x -1 do
      for j = 2, self.y -1 do
        grid[i][j] = grid2[i][j]
      end
    end
  end
  initmap()
  for _, iter in ipairs(settings.iterations) do
    for i = 1, iter.count do
      generation(iter.r1_cutoff,iter.r2_cutoff)
    end
  end
  self.grid = grid
end



function map:serialize()
  local array = {}
  for i = 1, self.x do
    local aux = (i-1)*self.y
    for j = 1, self.y do
      array[aux+j] = self.grid[i][j]
    end
  end
  return array
end

function map:load(location)
  self.x = location.height
  self.y = location.width
  local array = location.tiles
  local grid = {}
  for i = 1, self.x do
    grid[i] = {}
    local aux = (i-1)*self.y
    for j = 1, self.y do
      grid[i][j] = array[aux+j]
    end
  end
  self.grid = grid
end

function map:return_submap(size_x,size_y,curr_x,curr_y)
  local i_start = 1
  local j_start = 1
  local ppl_x = 1
  local ppl_y = 1
  if curr_x - size_x <= 0 then
    i_start = 1
    ppl_x = curr_x
  elseif curr_x + size_x > self.x then
    i_start = self.x - 2*size_x
    ppl_x = 2*size_x+1 - (self.x-curr_x)
  else
    i_start =  curr_x - size_x
    ppl_x = size_x + 1
  end

  if curr_y - size_y <= 0 then
    j_start = 1
    ppl_y = curr_y
  elseif curr_y + size_y > self.y then
    j_start = self.y - 2*size_y
    ppl_y = 2*size_y + 1 - (self.y - curr_y)
  else
    j_start =  curr_y - size_y
    ppl_y = size_y +1
  end
  local submap = {}
  for i = 1,  2*size_x + 1 do
    submap[i] = {}
    for j = 1,  2*size_y + 1 do
      submap[i][j] = self.grid[i_start + i - 1][j_start + j - 1]
    end
  end
  submap[ppl_x][ppl_y] = 'W'
  return map:new(2*size_x+1,2*size_y+1,submap)
end

function map:empty_cell()
  local x = 1
  local y = 1
  for i = 1, self.x do
    for j = 1, self.y do
      if self.grid[i][j] == self.Floor then
        return {x = i, y = j}
      end
    end
  end
end

function map:print()
  for i = 1, self.x do
    for j = 1, self.y do
      io.write(self.grid[i][j])
    end
    io.write("\n")
  end
  io.write("\n")
end


return map
