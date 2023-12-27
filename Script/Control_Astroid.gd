extends Node2D

var parent : Node
var velocity : Vector2

func _ready():
	parent = get_parent()
	velocity = parent.velocity
	pass

func _process(delta):
	if Input.get_axis("ui_left", "ui_right"):
		parent.velocity.x += Input.get_axis("ui_left", "ui_right") * 0.5
	if Input.get_axis("ui_down", "ui_up"):
		parent.velocity.y += Input.get_axis("ui_up", "ui_down") * 0.5
	pass # Replace with function body.
