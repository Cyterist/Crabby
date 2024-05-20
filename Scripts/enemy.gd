extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@onready var path_timer = $Path_timer
@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 400

var home_pos = Vector2.ZERO
var player = null
var health = 500

func _ready():
	print('readied')
	home_pos = self.global_position
	print(home_pos)

func _physics_process(_delta):
	animated_sprite_2d.play("default")
	if nav_agent.is_navigation_finished():
		print('nav finished')
		return
	
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	if dir == Vector2.ZERO:
		print('no movement')
	velocity = dir * SPEED
	
	move_and_slide()

func makepath():
	if player:
		print('pathing')
		nav_agent.target_position = player.global_position
		print(nav_agent.target_position)
	else:
		print('returning')
		nav_agent.target_position = home_pos
	

func _on_path_timer_timeout():
	print('timed out')
	makepath()


func _on_aggro_range_body_entered(body):
	if body.has_method("isPlayer"):
		print('detected player')
		player = body
		makepath()
		path_timer.start()
		


func _on_aggro_range_body_exited(_body):
	print('player left range')
	player = null
	
func take_damage(damage):
	print('hurt')
	health -= damage
	if health >= 0:
		queue_free()

