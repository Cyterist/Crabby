extends Area2D


var player = null
@onready var canvas_layer = $CanvasLayer


func _on_body_entered(body):
	if body.has_method("isPlayer"):
		print('detected player victory')
		player = body
		Engine.time_scale = 0
		canvas_layer.visible = true
