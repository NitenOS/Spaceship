extends CharacterBody2D

var spaceship_grid : Array

func _ready():
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	pass

func set_menace(grid_board : Array, size_case_board : int) -> Array:
	var spaceship_board : Array
	var vector_size_case_board := Vector2(size_case_board, size_case_board)
	for i_ in grid_board:
		if i_.x <= (position.x + size_case_board*2) and i_.x >= (position.x - size_case_board*2):
			if i_.y <= (position.y + size_case_board*2) and i_.y >= (position.y - size_case_board*2):
				spaceship_board.append(i_)
			pass
		pass
	return spaceship_board
	pass
