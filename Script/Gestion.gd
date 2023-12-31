extends Node2D

const control = preload("res://Object/Control_Astroid.tscn")
const asteroid = preload("res://Object/asteroid.tscn")
const spaceship = preload("res://Object/spaceship.tscn")
const texture_placeholder_asteroid_control = preload("res://Asset/Proto_user_rock.png")
const texture_placeholder_asteroid = preload("res://Asset/Proto_rock.png") 

var asteroid_on_screen : Array = []
var place_on_array : int = 0
var i : int = 0
var asteroid_on_control : Node2D
const max_asteroid : int = 20

var current_spaceship : CharacterBody2D
var spaceship_init_location := Vector2(500, 500)
var spaceship_current_life : int
var spaceship_current_look : int
const spaceship_max_life : int = 3
var grid_coord : Array
var spaceship_grid : Array
var spaceship_grid_menace : Array
var spaceship_as_location_to_move : Vector2 = spaceship_init_location

const max_time : float = 0.5
var time_left : float = max_time

func _ready():
	
	for _i in max_asteroid:
		asteroid_on_screen.append(null)
		pass
	
	# Spawn the first asteroid
	create_new_asteroid()
	create_new_spaceship(500, 500)
	gid_the_board()
	spaceship_grid_menace = check_menace_board()
	
	spaceship_grid = current_spaceship.set_menace(grid_coord, 100)
	
	# Take control of the first asteroid
	take_control()
	i += 1
	pass
	
func _process(delta):
	
	if wait_Xs(delta) :
		create_new_asteroid()
		time_left = max_time
		pass
		
	#if current_spaceship.is_moving == false: spaceship_current_look = spaceship_look_direction()
		
	#Check if a asteroid is out-of-screen
	# With this method we check le whole array every frame (I need to fix that... later)
	for j in asteroid_on_screen.size():
		if asteroid_on_screen[j] != null:
			if asteroid_on_screen[j].visible_on_screen.is_on_screen() == false and asteroid_on_screen[j].already_on_screen == true:
				asteroid_on_screen[j].queue_free()
				asteroid_on_screen[j] = null
				pass
			pass
		pass
		
	#Check if the asteroid on control is out-of-screen
	if asteroid_on_control != null:
		if asteroid_on_control.visible_on_screen.is_on_screen() == false and asteroid_on_control.already_on_screen == true:
			asteroid_on_control.queue_free()
			asteroid_on_control = null
			pass
		pass
		
	#Change the asteroid on control
	if Input.is_action_just_pressed("Change_Control"):
		
		#Thid case (but the first cause it's logic), the next object isn't an asteroid
		if asteroid_on_screen[i] == null:
			var end_loop : bool = true
			var init_i = i - 1
			if init_i == - 1: init_i = asteroid_on_screen.size() - 1
			#We make a loop of the array from i to i 
			while end_loop:
				i += 1
				if i >= asteroid_on_screen.size(): i=0
				if i == init_i:
					print("We don't find another asteroid, wait some second please !")
					end_loop = false
					pass 
				if asteroid_on_screen[i] != null: end_loop = false
				pass
			pass
			
		#Fist case, the next object is an asteroid and we have the control of an asteroid
		if asteroid_on_screen[i] != null and asteroid_on_control != null:
			#Old asteroid on control get neutral texture
			var asteroid_control : Node2D = asteroid_on_control.get_child(3)
			asteroid_control.queue_free()
			var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1)
			asteroid_sprite.texture = texture_placeholder_asteroid
			take_control()
			pass
			
		#Second case, the next object is an asteroid and we dont have the control of an asteroid
		if asteroid_on_screen[i] != null and asteroid_on_control == null:
			take_control()
			pass
			
		i += 1
		if i >= asteroid_on_screen.size(): i=0
		pass
		

	
	spaceship_grid_menace = check_menace_board()
	queue_redraw()
	if spaceship_as_location_to_move != move_spaceship():
		spaceship_as_location_to_move = move_spaceship()
		current_spaceship.move_spaceship_to(spaceship_as_location_to_move)
		pass
	pass
	
func _draw():
	for i_ in grid_coord:
		draw_circle(i_, 5, "BLACK")
	for i_ in spaceship_grid.size():
		if spaceship_grid_menace.size() > 0:
			if spaceship_grid_menace[i_]:
				draw_rect(Rect2(spaceship_grid[i_].x, spaceship_grid[i_].y, 10, 10), "RED")
			if !spaceship_grid_menace[i_]:
				draw_rect(Rect2(spaceship_grid[i_].x, spaceship_grid[i_].y, 10, 10), "BLUE")
	pass

func create_new_spaceship(_position_x, _posistion_y):
	
	var new_spaceship = spaceship.instantiate()
	new_spaceship.position = spaceship_init_location
	current_spaceship = new_spaceship
	add_child(new_spaceship)
	pass

#Create an asteroid
func create_new_asteroid():
	
	if asteroid_on_screen[place_on_array] == null:
		var new_asteroid = asteroid.instantiate()
		asteroid_on_screen[place_on_array] = new_asteroid
		add_child(new_asteroid)
		pass
	place_on_array += 1
	if place_on_array >= asteroid_on_screen.size(): place_on_array = 0
	pass

#Give the control of an asteroid to the player
func take_control():
	
	asteroid_on_control = asteroid_on_screen[i]
	
	#New asteroid on control get control texture
	var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1)
	asteroid_sprite.texture = texture_placeholder_asteroid_control
	var new_control = control.instantiate()
	asteroid_on_control.add_child(new_control)
	pass

#A simple func for wait
func wait_Xs(_delta):
	if time_left > 0:
		time_left -= _delta
		return false
	else:
		time_left = 0
		return true
		pass
	pass
	
func spaceship_look_direction() -> int:
	var closer_asteroid : int
	var shorter_distance : float
	for _i in max_asteroid:
		if asteroid_on_screen[_i] != null : 
			if shorter_distance == 0.0:
				closer_asteroid = _i
				shorter_distance = current_spaceship.position.distance_to(asteroid_on_screen[closer_asteroid].position)
				pass
			else:
				if shorter_distance > current_spaceship.position.distance_to(asteroid_on_screen[_i].position): 
					closer_asteroid = _i
					shorter_distance = current_spaceship.position.distance_to(asteroid_on_screen[closer_asteroid].position)
					pass
				pass
			pass
		pass
	current_spaceship.rotation = current_spaceship.position.angle_to_point(asteroid_on_screen[closer_asteroid].position)
	return closer_asteroid

func gid_the_board():
	var size_case_board : int = 100
	var grid : int = 1000 / size_case_board
	for i_ in grid:
		for j_ in grid:
			if i_ != 0 and j_ !=0 : grid_coord.append(Vector2(i_ * size_case_board, j_ * size_case_board))
			pass
		pass
	pass

func check_menace_board() -> Array:
	var grid_menace : Array
	for i_ in spaceship_grid.size():
		grid_menace.append(false)
		for j_ in asteroid_on_screen: 
			#It just work
			if j_ != null and (spaceship_grid[i_].distance_to(j_.position) < 100 or spaceship_grid[i_].distance_to(j_.position + j_.velocity) < 100):
				grid_menace[i_] = true
				break
				pass
			pass
		pass
	return grid_menace
	pass

func move_spaceship() -> Vector2:
	var position_to_move : Vector2 = current_spaceship.position
	var position_danger : bool = false
	for i_ in spaceship_grid.size():
		if spaceship_grid[i_] == current_spaceship.position and spaceship_grid_menace[i_]:
			position_danger = true
			break
			pass
		pass
	if position_danger:
		for i_ in spaceship_grid.size():
			if spaceship_grid_menace[i_]:
				position_to_move = spaceship_grid[i_]
				break
				pass
			pass
		pass
	return position_to_move
	pass
