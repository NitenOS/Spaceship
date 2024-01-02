extends CharacterBody2D
@onready var area_2d = $Area2D
@onready var text_score = $"../../Control/Score"

var init_position : Vector2
var init_rotation : float
var score : int = 0

func _ready():
	position = init_position
	pass

func _process(delta):
	pass

func _physics_process(delta):

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Asteroid"):
		print(body)
		get_parent().score_game += 100
		
		text_score.text = str(get_parent().score_game)
		body.queue_free()
		queue_free()
	pass # Replace with function body.
