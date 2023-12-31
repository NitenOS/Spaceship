extends CharacterBody2D

var spaceship_grid : Array
var destination : Vector2
var is_moving : bool = false

func _ready():
	destination = position
	pass

func _process(delta):
	if destination != position:
		rotation = position.angle_to_point(destination)
		velocity = transform.x * 200
		is_moving = true
		print(position)
		pass
	else:
		is_moving = false
		velocity = Vector2(0, 0)
		pass
	pass
	
func _physics_process(delta):
	move_and_slide()
	pass

func set_menace(grid_board : Array, size_case_board : int) -> Array:
	var distance : int = 1
	var spaceship_board : Array
	var vector_size_case_board := Vector2(size_case_board, size_case_board)
	for i_ in grid_board:
		if i_.x <= (position.x + size_case_board*distance) and i_.x >= (position.x - size_case_board*distance):
			if i_.y <= (position.y + size_case_board*distance) and i_.y >= (position.y - size_case_board*distance):
				spaceship_board.append(i_)
			pass
		pass
	return spaceship_board
	pass

func move_spaceship_to(destination_ : Vector2):
	destination = destination_
	pass
