extends Node2D
@onready var score = $Control/score


# Called when the node enters the scene tree for the first time.
func _ready():
	score.text = str(Singletone.last_game_score)
	Singletone.all_score.append(Singletone.last_game_score)
	print(Singletone.all_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Change_Control"):
		get_tree().change_scene_to_file("res://Level/LVL_main_menu.tscn")
	pass

func _draw():
	draw_rect(Rect2(0, 0, 1000, 1000), "BLACK")
	pass
