extends Area2D

@onready var respawn_timer = $RespawnTimer

func _on_body_entered(body):
	respawn_timer.start()


func _on_respawn_timer_timeout():
	get_tree().reload_current_scene()
