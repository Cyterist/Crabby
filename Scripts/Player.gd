extends CharacterBody2D

@onready var player = $AnimatedSprite2D
@onready var dash_cooldown_timer = %dash_cooldown_timer
@onready var dash_duration = %dash_duration
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_cooldown = %dash_cooldown
@onready var coyote_timer = $CoyoteTimer

const SPEED = 200.0
const JUMP_VELOCITY = -500.0
const SUPER_JUMP_VELOCITY = -700.0
const DASH_SPEED = 400
const DASH_COOLDOWN = 3

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
			dash_duration.start()
			dash_cooldown_timer.start()
			dash_cooldown.visible = true
			dash_cooldown.start_cooldown(DASH_COOLDOWN)

	# Handle jump and super jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif not coyote_timer.is_stopped() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("super_jump") and is_on_floor():
		velocity.y = SUPER_JUMP_VELOCITY

	# Movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if dash:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Coyote Time
	var was_on_floor = is_on_floor()

	move_and_slide()
	
	if was_on_floor and not is_on_floor() and not Input.is_action_just_pressed("jump"):
		coyote_timer.start()

func _on_dash_duration_timeout():
	dash = false

func _on_dash_cooldown_timer_timeout():
	can_dash = true
	dash_cooldown.visible = false
	dash_cooldown.reset()







