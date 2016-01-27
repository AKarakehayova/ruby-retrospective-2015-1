def move(snake, direction)
  grow(snake, direction).drop(1)
end

def next_position(snake, direction)
  [snake.last, direction].transpose.map { |x| x.reduce :+ }
end

def grow(snake, direction)
  snake.dup.push(next_position(snake, direction))
end

def new_food(food, snake, dimensions)
  xs, ys = (0...dimensions[:width]).to_a, (0...dimensions[:height]).to_a
  valid_positions = xs.product(ys)
  empty_positions = valid_positions - (food + snake)
  empty_positions.sample
end

def obstacle_ahead?(snake, direction, dimensions)
  movement = next_position(snake, direction)
  wall_ahead?(movement, dimensions) or snake.include?(movement)
end

def wall_ahead?(position, dimensions)
  x, y = position
  x < 0 or x >= dimensions[:width] or y < 0 or y >= dimensions[:height]
end

def danger?(snake, direction, dimensions)
  dead_after_one_move = obstacle_ahead?(snake, direction, dimensions)
  new_snake = move(snake, direction)
  dead_after_two_moves = obstacle_ahead?(new_snake, direction, dimensions)
  dead_after_one_move or dead_after_two_moves
end
