extends Area2D


func _on_body_entered(body):
	if body.has_method("isPlayer"):
		body.spawner.position = position
