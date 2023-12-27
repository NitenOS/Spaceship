extends CharacterBody2D

@onready var visible_on_screen : VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
var already_on_screen : bool = false

var velocity_multiplier : int = 1
var side : int

func _ready():
	spawn_off_screen()
	pass

func _process(delta):
	#print(velocity)
	if visible_on_screen.is_on_screen():
		already_on_screen = true
	pass

func _physics_process(delta):
	move_and_slide()
	#if is_off_scenne():
		#queue_free()
		#pass
	pass
	

func is_off_scenne() -> bool:
	var is_off_screen : bool = false
	if position.x < -100 or position.x > 1100 or position.y < -100 or position.y > 1100:
		is_off_screen = true
		pass
	return is_off_screen
	pass

func spawn_off_screen():
	var wich_side : int = randi_range(0, 3)
	side = wich_side
	#side up
	if wich_side == 0:
		var position_x : int = randi_range(0, 1000)
		var position_y : int = randi_range(0, 100)
		position = Vector2(position_x,position_y)
		
		var velocity_x : int = randi_range(-25, 25) * velocity_multiplier
		var velocity_y : int = randi_range(0, 100) * velocity_multiplier
		velocity = Vector2(velocity_x,velocity_y)
		pass
	#side right
	if wich_side == 1:
		var position_x : int = randi_range(900, 1000)
		var position_y : int = randi_range(0, 1000)
		position = Vector2(position_x,position_y)
		
		var velocity_x : int = randi_range(-100, 0) * velocity_multiplier
		var velocity_y : int = randi_range(-25, 52) * velocity_multiplier
		velocity = Vector2(velocity_x,velocity_y)
		pass
	#side down
	if wich_side == 2:
		var position_x : int = randi_range(0, 1000)
		var position_y : int = randi_range(900, 1000)
		position = Vector2(position_x,position_y)
		
		var velocity_x : int = randi_range(-25, -25) * velocity_multiplier
		var velocity_y : int = randi_range(-100, 0) * velocity_multiplier
		velocity = Vector2(velocity_x,velocity_y)
		pass
	#side left
	if wich_side == 3:
		var position_x : int = randi_range(0, 100)
		var position_y : int = randi_range(0, 1000)
		position = Vector2(position_x,position_y)
		
		var velocity_x : int = randi_range(0, 100) * velocity_multiplier
		var velocity_y : int = randi_range(-25, 25) * velocity_multiplier
		velocity = Vector2(velocity_x,velocity_y)
		pass
	pass
