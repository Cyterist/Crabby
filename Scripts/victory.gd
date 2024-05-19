extends Area2D


var player = null

func _on_body_entered(body):
	if body.has_method("isPlayer"):
		player = body
		Engine.time_scale = 0
