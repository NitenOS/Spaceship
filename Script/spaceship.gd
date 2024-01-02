extends CharacterBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D
const BULLET = preload("res://Object/bullet.tscn")

var spaceship_grid : Array
var destination : Vector2
var is_moving : bool = false
var init_time_bullet : float = 1
var time_bullet : float = init_time_bullet
var bullet_array : Array

func _ready():
	destination = position
	pass

func _process(delta):
	if is_moving:
		rotation = position.angle_to_point(destination)
		velocity = transform.x * 500
		if position.distance_to(destination) < 10:
			position = destination
			velocity = Vector2(0, 0)
			is_moving = false
			pass
		pass
	time_bullet -= delta
	if time_bullet <= 0:
		shoot_bullet()
		time_bullet = init_time_bullet
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
	is_moving = true
	pass

func shoot_bullet():
	var new_bullet = BULLET.instantiate()
	bullet_array.append(new_bullet)
	get_parent().add_child(new_bullet)
	new_bullet.scale = Vector2(0.5, 0.5)
	new_bullet.position = position
	new_bullet.rotation = rotation
	new_bullet.velocity = transform.x * 1000
	pass
