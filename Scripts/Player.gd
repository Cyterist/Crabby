extends CharacterBody2D

@onready var player = $AnimatedSprite2D
@onready var dash_cooldown = $dash_cooldown
@onready var dashtimer = $dashtimer
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 50.0
const JUMP_VELOCITY = -200.0
const SUPER_JUMP_VELOCITY = -300.0
const DASH_SPEED = 400

var dash = false
var can_dash = true
 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("dash") and can_dash:
			dash = true
			can_dash = false
			dashtimer.start()
			dash_cooldown.start()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("super_jump") and is_on_floor():
		velocity.y = SUPER_JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if dash:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	move_and_slide()


func _on_dash_cooldown_timeout():
	can_dash = true


func _on_dashtimer_timeout():
	dash = false
