extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@onready var path_timer = $Path_timer

const SPEED = 40

var home_pos = Vector2.ZERO
var player = null
var chasing = false
var health = 50

func _ready():
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 3
	nav_agent.target_desired_distance = 3

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		return
	
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	velocity = dir * SPEED
	
	move_and_slide()

func makepath():
	if player:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = home_pos
	

func _on_path_timer_timeout():
	makepath()


func _on_aggro_range_body_entered(body):
	if body.is_in_group("player"):
		player = body
		makepath()
		path_timer.start()


func _on_aggro_range_body_exited(body):
	player = null
	chasing = false
	
func take_damage(damage):
	print("damaged")

