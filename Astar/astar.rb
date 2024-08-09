require 'set'

class AStar
  def initialize(grid)
    @grid = grid
    @rows = grid.size
    @cols = grid.first.size
    @open_set = {}
    @closed_set = Set.new
  end

  def find_path(start, goal)
    start_node = Node.new(start)
    start_node.g = 0
    start_node.h = heuristic(start, goal)
    start_node.f = start_node.h
    @open_set[start] = start_node

    until @open_set.empty?
      current = extract_min_node
      return reconstruct_path(current) if current.position == goal

      @open_set.delete(current.position)
      @closed_set.add(current.position)

      neighbors(current.position).each do |neighbor_pos|
        next if @closed_set.include?(neighbor_pos) || @grid[neighbor_pos[0]][neighbor_pos[1]] == 1

        tentative_g = current.g + movement_cost(current.position, neighbor_pos)
        neighbor_node = @open_set[neighbor_pos] ||= Node.new(neighbor_pos)

        if tentative_g < neighbor_node.g
          neighbor_node.parent = current
          neighbor_node.g = tentative_g
          neighbor_node.h = heuristic(neighbor_pos, goal)
          neighbor_node.f = neighbor_node.g + neighbor_node.h
        end
      end
    end

    nil
  end

  private

  def extract_min_node
    @open_set.values.min_by(&:f)
  end

  def neighbors(pos)
    x, y = pos
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    diagonals = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    all_directions = directions + diagonals

    all_directions.map do |dx, dy|
      [x + dx, y + dy]
    end.select do |nx, ny|
      nx.between?(0, @rows - 1) && ny.between?(0, @cols - 1)
    end
  end

  def heuristic(pos0, pos1)
    dx = (pos0[0] - pos1[0]).abs
    dy = (pos0[1] - pos1[1]).abs
    [dx, dy].max
  end

  def movement_cost(from_pos, to_pos)
    dx = (from_pos[0] - to_pos[0]).abs
    dy = (from_pos[1] - to_pos[1]).abs
    dx == 1 && dy == 1 ? Math.sqrt(2) : 1
  end

  def reconstruct_path(node)
    path = []
    while node
      path << node.position
      node = node.parent
    end
    path.reverse
  end

  class Node
    attr_accessor :position, :parent, :g, :h, :f

    def initialize(position)
      @position = position
      @parent = nil
      @g = Float::INFINITY
      @h = 0
      @f = Float::INFINITY
    end
  end
end
