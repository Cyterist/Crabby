extends GPUParticles2D

@onready var gpu_particles_2d = $"."
@onready var bubble_timer = $"../BubbleTimer"

func _process(_delta):
	if Input.is_action_just_pressed("super_jump") and bubble_timer.is_stopped():
		gpu_particles_2d.emitting = true
		bubble_timer.start()

func _on_bubble_timer_timeout():
	gpu_particles_2d.emitting = false
