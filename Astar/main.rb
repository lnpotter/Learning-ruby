require_relative 'astar'

def print_grid(grid, path = nil)
  grid.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      pos = [x, y]
      if path && path.include?(pos)
        print 'O '
      elsif cell == 1
        print '# '
      else
        print '. '
      end
    end
    puts
  end
end

def generate_random_grid(rows, cols, obstacle_probability)
  Array.new(rows) do
    Array.new(cols) do
      rand < obstacle_probability ? 1 : 0
    end
  end
end

rows = 20
cols = 20
obstacle_probability = 0.3
start = [0, 0]
goal = [19, 19]

grid = generate_random_grid(rows, cols, obstacle_probability)

grid[start[0]][start[1]] = 0
grid[goal[0]][goal[1]] = 0

astar = AStar.new(grid)
path = astar.find_path(start, goal)

puts "Grid:"
print_grid(grid, path)

puts "\nPath:"
if path
  path.each { |pos| puts "-> #{pos.inspect}" }
else
  puts "No path found"
end