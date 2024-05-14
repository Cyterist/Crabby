extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@onready var path_timer = $Path_timer

const SPEED = 20

var player = null
var chasing = false
var dir = 0
var health = 50



func _physics_process(_delta):
	if chasing:
		dir = to_local(nav_agent.get_next_path_position()).normalized()
	else:
		dir = Vector2(0,0)
	
	velocity = dir * SPEED
	
	move_and_slide()

func makepath():
	nav_agent.target_position = player.global_position
	

func _on_path_timer_timeout():
	makepath()


func _on_aggro_range_body_entered(body):
	player = body
	chasing = true
	makepath()
	path_timer.start()


func _on_aggro_range_body_exited(body):
	player = null
	chasing = false
	
	path_timer.stop()

func take_damage():
	print("damaged")
