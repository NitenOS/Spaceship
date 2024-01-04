extends Node2D

@onready var play = $Control/buttun_control/Play
@onready var quit = $Control/buttun_control/Quit

@onready var score_1 = $Control/Score_control/score1
@onready var score_2 = $Control/Score_control/score2
@onready var score_3 = $Control/Score_control/score3
@onready var score_4 = $Control/Score_control/score4
@onready var score_5 = $Control/Score_control/score5
var tab_score : Array
var tab_button : Array
var button_nav : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tab_button = [play, quit]
	tab_score = [score_1, score_2, score_3, score_4, score_5]
	Singletone.all_score.sort_custom(func(a, b): return a > b)

	for i_ in tab_score.size():
		if i_ >= Singletone.all_score.size(): break
		tab_score[i_].text = str(Singletone.all_score[i_])
		tab_score[i_].visible = true
		pass
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up"): 
		tab_button[button_nav].get_child(0).visible = false
		button_nav -= 1
		if button_nav <= -1 : button_nav = 1
		tab_button[button_nav].get_child(0).visible = true
	if Input.is_action_just_pressed("ui_down"): 
		tab_button[button_nav].get_child(0).visible = false
		button_nav += 1
		if button_nav >= 2 : button_nav = 0
		tab_button[button_nav].get_child(0).visible = true
	if Input.is_action_just_pressed("Change_Control") and button_nav == 0: get_tree().change_scene_to_file("res://Level/LVL_Main.tscn")
	if Input.is_action_just_pressed("Change_Control") and button_nav == 1: get_tree().quit()
	pass

func _draw():
	draw_rect(Rect2(0, 0, 1000, 1000), "BLACK")
	pass
