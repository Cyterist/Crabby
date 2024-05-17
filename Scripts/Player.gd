extends CharacterBody2D

@onready var player = $AnimatedSprite2D
@onready var dash_cooldown_timer = %dash_cooldown_timer
@onready var dash_duration = %dash_duration
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_cooldown = %dash_cooldown
@onready var coyote_timer = %CoyoteTimer
@onready var attack_collision = $attack/CollisionShape2D

const SPEED = 200.0
const JUMP_VELOCITY = -490.0
const SUPER_JUMP_VELOCITY = -700.0
const DASH_SPEED = 650
const DASH_COOLDOWN = 3

var health = 100
var dash = false
var can_dash = true
var attacking = false
var can_act = true
 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if can_act:
		if Input.is_action_just_pressed("dash") and can_dash:
				dash = true
				can_dash = false
				dash_duration.start()
				dash_cooldown_timer.start()
				dash_cooldown.visible = true
				dash_cooldown.start_cooldown(DASH_COOLDOWN)
		
		# Handle Attacking
		if Input.is_action_just_pressed("attack"):
			attacking = true
			attack_collision.disabled = false

		# Handle jump and super jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif not coyote_timer.is_stopped() and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

		# Movement
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			if dash:
				velocity.x = direction * DASH_SPEED
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
		if Input.is_action_just_pressed("super_jump") and is_on_floor() and direction == 0:
			velocity.y = SUPER_JUMP_VELOCITY
		
			# Flip the sprite
		if direction > 0:
			animated_sprite.flip_h = false
			get_node("attack").set_scale(Vector2(1, 1))
		elif direction < 0:
			animated_sprite.flip_h = true
			get_node("attack").set_scale(Vector2(-1, 1))

		# Animations
		if not attacking:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
		else:
			animated_sprite.play("Attack")
			
		# Coyote Time
		var was_on_floor = is_on_floor()

		move_and_slide()
		
		if was_on_floor and not is_on_floor() and not Input.is_action_just_pressed("jump"):
			coyote_timer.start()

# Used for has_method() checks
func isPlayer():
	pass

func damage():
	print(health)
	
# Signals
func _on_dash_duration_timeout():
	dash = false

func _on_dash_cooldown_timer_timeout():
	can_dash = true
	dash_cooldown.visible = false
	dash_cooldown.reset()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "Attack":
		attack_collision.disabled = true
		attacking = false


func _on_attack_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)

