extends Node2D

var parent : Node
var velocity : Vector2
var power_control : float = 2

func _ready():
	parent = get_parent()
	velocity = parent.velocity
	pass

func _process(delta):
	if Input.get_axis("ui_left", "ui_right"):
		parent.velocity.x += Input.get_axis("ui_left", "ui_right") * power_control
		if parent.velocity.x < -400 : parent.velocity.x = -400
		if parent.velocity.x > 400 : parent.velocity.x = 400
	if Input.get_axis("ui_down", "ui_up"):
		parent.velocity.y += Input.get_axis("ui_up", "ui_down") * power_control
		if parent.velocity.y < -400 : parent.velocity.y = -400
		if parent.velocity.y > 400 : parent.velocity.y = 400
		
	
	pass # Replace with function body.
