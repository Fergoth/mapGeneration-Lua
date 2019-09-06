FLOOR_CELL = "."
WALL_CELL = "#"

map_file = "map.txt"

grid = {}
grid2 = {}
checked = {}

math.randomseed(os.time())

fillprob = 40
r1_cutoff = 5
r2_cutoff = 2
x = 500
y = 500
iterations = 7
fileWrite = io.open(tostring(x).."x"..tostring(y).."map.txt","w")
fileWrite:write("\n")
fileWrite:close()

function dfs(x1,y1,n)
  stack = {}
  table.insert(stack,{x1,y1})
  while #stack > 0 do
    curr = table.remove(stack)
    x1 = curr[1]
    y1 = curr[2]
    checked[x1][y1] = n
    for i = -1 , 1 do
      for j = -1 , 1 do
        if x>=x1+i and x1+i>=1 and y>=y1+j and y1+j>=1 and checked[x1+i][y1+j]=='0' and grid[x1+i][y1+j] == FLOOR_CELL then table.insert(stack,{x1+i,y1+j}) end
      end
    end
  end
end




function write_to_file(arr)
  fileWrite = io.open(tostring(x).."x"..tostring(y).."map.txt","a")

  for i = 1, x do
    for j = 1, y do
      fileWrite:write(arr[i][j])
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
    checked[i] = {}
    for j = 1, y do
      checked[i][j] = '0'
    end
  end

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

function generation(r1_cutof,r2_cutof)
  for i = 2, x-1 do
    for j = 2, y-1 do
      adjcout_r1, adjcount_r2 = 0,0
      for ii = -1, 1 do
        for jj = -1, 1 do
          if grid[i+ii][j+jj] == WALL_CELL then adjcout_r1 = adjcout_r1+1 end
        end
      end

      for ii = i-2, i+2 do
        for jj =j-2, j+2 do
          if not ((math.abs(ii-i) == 2 and math.abs(jj-j) == 2) or (ii<1 or jj<1 or ii>x or jj>x)) then
            if grid[ii][jj] == WALL_CELL then adjcount_r2 = adjcount_r2 + 1 end
          end
        end
      end

      if adjcout_r1 >= r1_cutof or adjcount_r2<=r2_cutof then
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
for i = 1 , 4 do
  generation(5,1)
end

for i = 1, 3 do
  generation(5,0)
end


n = {"a","b","c","d","e","f","g","h","i","k"}

for i = 2,x-1 do
  for j = 2, y-1 do
    if grid[i][j] == FLOOR_CELL and checked[i][j] == '0' then
      dfs(i,j,table.remove(n))
    end
  end
end
write_to_file(checked)
