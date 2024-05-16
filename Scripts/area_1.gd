extends Node2D

@onready var animation_player = $area1cutscene/AnimationPlayer
@onready var camera_2d = $area1cutscene/Path2D/PathFollow2D/Camera2D

var player = null
var is_transitioning = false

var is_pathfollowing = false

func _physics_process(delta):
	if is_pathfollowing:
		var pathfollower = $area1cutscene/Path2D/PathFollow2D

		if is_transitioning:
			player.position.x -= 1.15
			if pathfollower.progress_ratio > 0.5:
				pathfollower.progress_ratio += 0.01
			else:
				pathfollower.progress_ratio += 0.020
			
			if pathfollower.progress_ratio >= 1:
				transitionend()

func _on_playerdetection_body_entered(body):
	if body.has_method("isPlayer"):
		player = body
		screentransition()

func screentransition():
	is_transitioning = true
	player.camera.enabled = false
	camera_2d.enabled = true
	is_pathfollowing = true
	player.can_act = false
	
func transitionend():
	is_pathfollowing = false
	is_transitioning = false
	camera_2d.enabled = false
	player.camera.enabled = true
	player.can_act = true
