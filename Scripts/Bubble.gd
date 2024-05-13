extends GPUParticles2D

@onready var gpu_particles_2d = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("super_jump"):
		gpu_particles_2d.emitting = not gpu_particles_2d.emitting
