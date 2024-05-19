extends Node2D

var paused = false
@onready var game = $"."
@onready var pause = $Pause


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			paused = false
			game.unpause_game()
		else:
			paused = true
			game.pause_game()

func pause_game():
	Engine.time_scale = 0
	pause.visible = true
	

func unpause_game():
	Engine.time_scale = 1
	pause.visible = false
	
