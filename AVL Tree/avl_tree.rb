class Node
  attr_accessor :value, :left, :right, :height

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @height = 1
  end
end

class AVLTree
  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_rec(@root, value)
  end

  def delete(value)
    @root = delete_rec(@root, value)
  end

  def in_order
    in_order_rec(@root)
    puts
  end

  private

  def insert_rec(node, value)
    return Node.new(value) unless node

    if value < node.value
      node.left = insert_rec(node.left, value)
    elsif value > node.value
      node.right = insert_rec(node.right, value)
    else
      return node
    end

    node.height = 1 + [height(node.left), height(node.right)].max

    balance_node(node)
  end

  def delete_rec(node, value)
    return node unless node

    if value < node.value
      node.left = delete_rec(node.left, value)
    elsif value > node.value
      node.right = delete_rec(node.right, value)
    else
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end

      min_larger_node = find_min(node.right)
      node.value = min_larger_node.value
      node.right = delete_rec(node.right, min_larger_node.value)
    end

    node.height = 1 + [height(node.left), height(node.right)].max

    balance_node(node)
  end

  def find_min(node)
    current = node
    current = current.left while current.left
    current
  end

  def height(node)
    node ? node.height : 0
  end

  def balance_factor(node)
    node ? height(node.left) - height(node.right) : 0
  end

  def balance_node(node)
    balance = balance_factor(node)

    if balance > 1
      if balance_factor(node.left) < 0
        node.left = rotate_left(node.left)
      end
      return rotate_right(node)
    end

    if balance < -1
      if balance_factor(node.right) > 0
        node.right = rotate_right(node.right)
      end
      return rotate_left(node)
    end

    node
  end

  def rotate_right(y)
    x = y.left
    t2 = x.right

    x.right = y
    y.left = t2

    y.height = 1 + [height(y.left), height(y.right)].max
    x.height = 1 + [height(x.left), height(x.right)].max

    x
  end

  def rotate_left(x)
    y = x.right
    t2 = y.left

    y.left = x
    x.right = t2

    x.height = 1 + [height(x.left), height(x.right)].max
    y.height = 1 + [height(y.left), height(y.right)].max

    y
  end

  def in_order_rec(node)
    return unless node

    in_order_rec(node.left)
    print "#{node.value} "
    in_order_rec(node.right)
  end
end
