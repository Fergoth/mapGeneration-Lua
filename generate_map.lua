FLOOR_CELL = "."
WALL_CELL = "#"

map_file = "map.txt"

grid = {}
grid2 = {}

math.randomseed(os.time())

fillprob = 40
r1_cutoff = 5
r2_cutoff = 2
x = 100
y = 100
iterations = 5
fileWrite = io.open(tostring(x).."x"..tostring(y).."map.txt","w")
fileWrite:write("\n")
fileWrite:close()

function write_to_file(n)
  fileWrite = io.open(tostring(x).."x"..tostring(y).."map.txt","a")
  fileWrite:write("generation"..tostring(n).."\n")
  for i = 1, x do
    for j = 1, y do
      fileWrite:write(grid[i][j])
    end
    fileWrite:write("\n")
  end
  fileWrite:close()
end

function randpick()
  if math.random(100) < fillprob then return WALL_CELL else return FLOOR_CELL end
end

function initmap()
  for i = 1, x do
    grid[i] = {}
    for j = 1, y do
      grid[i][j] = randpick()
    end
  end

  for i = 1, x do
    grid2[i] = {}
    for j = 1, y do
      grid2[i][j] = WALL_CELL
    end
  end

  for xi = 1, x do
    grid[xi][1],grid[xi][y] = WALL_CELL,WALL_CELL
  end
  for yi = 1, y do
    grid[1][yi],grid[x][yi] = WALL_CELL,WALL_CELL
  end
end

function generation()
  for i = 2, x-1 do
    for j = 2, y-1 do
      adjcout_r1, adjcount_r2 = 0,0
      for ii = -1, 1 do
        for jj = -1, 1 do
          if grid[i+ii][j+jj] == WALL_CELL then adjcout_r1 = adjcout_r1+1 end
        end
      end

      for ii = -2, 2 do
        for jj =-2, 2 do
          if not (math.abs(ii-i) == 2 and math.abs(jj-j) == 2) or (ii<1 or jj<1 or ii>x or jj>x) then
            if grid[i][j] == WALL_CELL then adjcount_r2 = adjcount_r2 + 1 end
          end
        end
      end

      if adjcout_r1 >= r1_cutoff or adjcount_r2>=r2_cutoff then
        grid2[i][j] = WALL_CELL
      else
        grid2[i][j] = FLOOR_CELL
      end
    end
  end
  for i = 2, x-1 do
    for j = 2, y-1 do
      grid[i][j] = grid2[i][j]
    end
  end
end

initmap()
for i = 1 , iterations do
  generation()
  write_to_file(i)
end
