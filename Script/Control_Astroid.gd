extends Node2D

var parent : Node
var velocity : Vector2
var power_control : float = 1

func _ready():
	parent = get_parent()
	velocity = parent.velocity
	pass

func _process(delta):
	if Input.get_axis("ui_left", "ui_right"):
		parent.velocity.x += Input.get_axis("ui_left", "ui_right") * power_control
	if Input.get_axis("ui_down", "ui_up"):
		parent.velocity.y += Input.get_axis("ui_up", "ui_down") * power_control
	
	
	pass # Replace with function body.
	
