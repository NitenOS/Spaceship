extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	pass
