extends Area2D

@onready var respawn_timer = $RespawnTimer
var player = null

func _on_body_entered(body):
	if body.has_method("isPlayer"):
		player = body
		player.can_act = false
		respawn_timer.start()


func _on_respawn_timer_timeout():
	player.queue_free()
	player.can_act = true
