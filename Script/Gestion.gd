extends Node2D

const control = preload("res://Object/Control_Astroid.tscn")
const asteroid = preload("res://Object/asteroid.tscn")
const texture_placeholder_asteroid_control = preload("res://Asset/Proto_user_rock.png")
const texture_placeholder_asteroid = preload("res://Asset/Proto_rock.png")

var asteroid_on_screen : Array = [null, null, null, null, null, null, null, null, null, null, null]
var place_on_array : int = 0
var i : int = 0
var asteroid_on_control : Node2D

const max_time : int = 1
var time_left : float = max_time
const max_asteroid : int = 5
var idx : int = 0


func _ready():
	
	# Spawn the first asteroid
	create_new_asteroid()
	
	# Take control of the first asteroid
	asteroid_on_control = asteroid_on_screen[i]
	var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1)
	asteroid_sprite.texture = texture_placeholder_asteroid_control
	var new_control = control.instantiate()
	asteroid_on_control.add_child(new_control)
	i += 1
	pass
	
func _process(delta):
	
	if wait_Xs(delta) :
		create_new_asteroid()
		time_left = max_time
		print("oui")
		pass
		
	# With this method we check le whole array every frame
	for j in asteroid_on_screen.size():
		if asteroid_on_screen[j] != null:
			if asteroid_on_screen[j].visible_on_screen.is_on_screen() == false and asteroid_on_screen[j].already_on_screen == true:
				asteroid_on_screen[j].queue_free()
				asteroid_on_screen[j] = null
				pass
			pass
		pass
		

	if asteroid_on_control != null:
		if asteroid_on_control.visible_on_screen.is_on_screen() == false and asteroid_on_control.already_on_screen == true:
			asteroid_on_control.queue_free()
			asteroid_on_control = null
			pass
		pass
		
	#Change the asteroid on control
	if Input.is_action_just_pressed("Change_Control"):
		if asteroid_on_screen[i] == null:
			for _i in asteroid_on_screen.size():
				if asteroid_on_screen[_i] != null: i = _i
				pass
			pass
		if asteroid_on_screen[i] != null and asteroid_on_control != null:
			#Old asteroid on control get neutral texture
			var asteroid_sprite : Sprite2D = asteroid_on_control.get_child(1)
			asteroid_sprite.texture = texture_placeholder_asteroid
			take_control()
			pass
		if asteroid_on_screen[i] != null and asteroid_on_control == null:
			take_control()
			pass
		i += 1
		if i >= asteroid_on_screen.size(): i=0
		pass
		
	#asteroid_on_screen.sort()
	#print(i) #UN PRINT
	#print(asteroid_on_screen) #UN PRINT
	#print(asteroid_on_control) #UN PRINT
	pass

#Give the control of an asteroid to the player
func take_control():

	asteroid_on_control = asteroid_on_screen[i]
	print(asteroid_on_screen[i])
	
	#New asteroid on control get control texture
	var asteroid_sprite : Sprite2D= asteroid_on_control.get_child(1)
	asteroid_sprite.texture = texture_placeholder_asteroid_control
	var new_control = control.instantiate()
	asteroid_on_control.add_child(new_control)
	pass

#Create an asteroid
func create_new_asteroid():
	
	if asteroid_on_screen[place_on_array] == null:
		print(place_on_array)
		var new_asteroid = asteroid.instantiate()
		asteroid_on_screen[place_on_array] = new_asteroid
		add_child(new_asteroid)
		pass
	place_on_array += 1
	if place_on_array >= asteroid_on_screen.size(): place_on_array = 0
	pass

#A simple func for wait
func wait_Xs(_delta):
	if time_left > 0:
		time_left -= _delta
		#print(time_left) #UN PRINT
		return false
	else:
		time_left = 0
		return true
		pass
	pass
