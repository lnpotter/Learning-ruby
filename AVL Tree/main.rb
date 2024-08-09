require_relative 'avl_tree'

avl = AVLTree.new

puts "\nInserting values into the AVL tree:"
[10, 20, 30, 40, 50, 25, 39, 39, 42].each do |value|
  avl.insert(value)
  avl.in_order
end

puts "\nDeleting values into the AVL tree:"
[10, 20].each do |value|
  avl.delete(value)
  avl.in_order
end
