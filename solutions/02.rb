def move(snake, direction)
  new_snake = Array.new(snake)
  new_snake.delete_at(0)
  length = new_snake.length
  new_snake[length] = next_position(new_snake, direction)
  new_snake
end

def next_position(snake, direction)
  [snake.last, direction].transpose.map { |x| x.reduce :+ }
end


def grow(snake, direction)
  new_snake = Array.new(snake)
  length = new_snake.length
  new_snake[length] = next_position(new_snake, direction)
  new_snake
end

def new_food(food, snake, dimensions)
  generated_food = [rand(dimensions[:width]), rand(dimensions[:height])]
  part_of_the_snake = snake.include? generated_food
  already_exists = (food - generated_food).empty?
  if !part_of_the_snake and !already_exists
    generated_food
  else new_food(food, snake, dimensions)
  end
end

def obstacle_ahead?(snake, direction, dimensions)
  move = next_position(snake, direction)
  if snake.include? move or move[0] < 0 or move[1] < 0
    true
  elsif move[0] >= dimensions[:width] or move[1] >= dimensions[:height]
    true
  else false
  end
end

def danger? (snake, direction, dimensions)
  dead_after_one_move = obstacle_ahead?(snake, direction, dimensions)
  new_snake = move(snake,direction)
  dead_after_two_moves = obstacle_ahead?(new_snake, direction, dimensions)
  dead_after_one_move or dead_after_two_moves
end
