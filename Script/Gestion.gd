extends Node2D

const control = preload("res://Object/Control_Astroid.tscn")
const asteroid = preload("res://Object/asteroid.tscn")
const spaceship = preload("res://Object/spaceship.tscn")
const texture_placeholder_asteroid_control = preload("res://Asset/asteroid3control.png")
const texture_placeholder_asteroid = preload("res://Asset/asteroid3.png")
const ASTEROID_2 = preload("res://Asset/asteroid2.png")
const ASTEROID_1 = preload("res://Asset/asteroid1.png")
const CONTROL = preload("res://Asset/control.png")

@onready var spaceship_life_node = $"../Spaceship_life"
@onready var score = $"../Control/Score"


var asteroid_on_screen : Array = []
var place_on_array : int = 0
var i : int = 0
var asteroid_on_control : Node2D
const max_asteroid : int = 20

var current_spaceship : CharacterBody2D
var spaceship_init_location := Vector2(500, 500)
var spaceship_current_life : int
var spaceship_current_look : int
var spaceship_life : int = 3
var grid_coord : Array
var size_case_board : int = 50
var spaceship_grid : Array
var spaceship_grid_menace : Array
var spaceship_as_location_to_move : Vector2 = spaceship_init_location
var spaceship_respawn_time : float = 2
var init_spaceship_respawn_time : float = 2
var is_spaceship_respawning : bool = false

var score_game : int = 0
const max_time : float = 0.5
var time_left : float = max_time


func _ready():
	
	Engine.time_scale = 1
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
		
	spaceship_respawn(delta)
	
	if !is_spaceship_respawning and current_spaceship.is_moving == false: spaceship_current_look = spaceship_look_direction()
		
	# Check if a asteroid is out-of-screen
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
			var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1).get_child(0)
			asteroid_sprite.modulate.a = 0
			#asteroid_sprite.texture = texture_placeholder_asteroid
			take_control()
			pass
			
		#Second case, the next object is an asteroid and we dont have the control of an asteroid
		if asteroid_on_screen[i] != null and asteroid_on_control == null:
			take_control()
			pass
			
		i += 1
		if i >= asteroid_on_screen.size(): i=0
		pass
		
	
	#Destroy and respawn spaceship
	if !is_spaceship_respawning and asteroid_on_screen[spaceship_current_look] != null and current_spaceship.position.distance_to(asteroid_on_screen[spaceship_current_look].position) <= 50:
		print("Hit")
		current_spaceship.queue_free()
		is_spaceship_respawning = true
		pass

	if !is_spaceship_respawning:
		spaceship_grid = current_spaceship.set_menace(grid_coord, size_case_board)
		spaceship_grid_menace = check_menace_board()
		pass
	
	if !is_spaceship_respawning and spaceship_is_in_danger() and current_spaceship.is_moving == false:
		current_spaceship.move_spaceship_to(find_new_position())
		pass
	
	
func _draw():

	draw_rect(Rect2(0, 0, 1000, 1000), "BLACK")
	var nb_star : int = randi_range(10, 500)
	var color : String = "WHITE"
	for i_ in nb_star:
		print(i_%2)
		if i_ %2: 
			color  = "GRAY"
		else:
			color = "WHITE"
			pass
		draw_circle(Vector2(randi_range(0, 1000), randi_range(0, 1000)), randf_range(0, 2), color)
		pass
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
	for i_ in asteroid_on_screen:
		if i_ != null: current_spaceship.add_collision_exception_with(i_)
	add_child(new_spaceship)
	pass

#Create an asteroid
func create_new_asteroid():
	
	if asteroid_on_screen[place_on_array] == null:
		var new_asteroid = asteroid.instantiate()
		asteroid_on_screen[place_on_array] = new_asteroid
		for i_ in asteroid_on_screen:
			if i_ != null : new_asteroid.add_collision_exception_with(i_)
		if !is_spaceship_respawning: new_asteroid.add_collision_exception_with(current_spaceship)
		add_child(new_asteroid)
		pass
	place_on_array += 1
	if place_on_array >= asteroid_on_screen.size(): place_on_array = 0
	pass

#Give the control of an asteroid to the player
func take_control():
	
	asteroid_on_control = asteroid_on_screen[i]
	
	#New asteroid on control get control texture
	var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1).get_child(0)
	#asteroid_sprite.texture = texture_placeholder_asteroid_control
	asteroid_sprite.modulate.a = 1
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

func spaceship_is_in_danger() -> bool:
	for i_ in spaceship_grid.size():
		if spaceship_grid[i_] == current_spaceship.position and spaceship_grid_menace[i_]:
			return true
			pass
		pass
	return false
	pass

func find_new_position() -> Vector2:
	var position_to_move : Vector2 = current_spaceship.position
	if spaceship_is_in_danger():
		var tab_ : Array 
		for j_ in spaceship_grid.size(): tab_.append(j_)
		tab_.shuffle()
		for i_ in spaceship_grid.size():
			if !spaceship_grid_menace[tab_[i_]]:
				position_to_move = spaceship_grid[tab_[i_]]
				break
				pass
			pass
		pass
	return position_to_move
	pass

func spaceship_respawn(delta_):
	if is_spaceship_respawning:
		spaceship_respawn_time -= delta_
		print(spaceship_respawn_time)
		if  spaceship_respawn_time <= 0:
			spaceship_life -= 1
			spaceship_life_node.get_child(spaceship_life).modulate.a = 0
			if spaceship_life == 0:
				Singletone.last_game_score = score.text
				get_tree().change_scene_to_file("res://Level/LVL_game_over.tscn")
				pass
			create_new_spaceship(500, 500)
			is_spaceship_respawning = false
			spaceship_respawn_time = init_spaceship_respawn_time
	pass
