extends Control

@onready var cooldown_bar = $cooldown_bar



func start_cooldown(time):
	var tween = get_tree().create_tween()
	tween.tween_property(cooldown_bar, "value", 100, time).set_trans(Tween.TRANS_LINEAR)
	
func reset():
	var tween = get_tree().create_tween()
	tween.tween_property(cooldown_bar, "value", 0, 0).set_trans(Tween.TRANS_LINEAR)
