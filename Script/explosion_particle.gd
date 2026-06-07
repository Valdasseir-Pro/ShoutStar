extends CPUParticles2D


func start() -> void:
	
	emitting = true
	
	await finished
	
	queue_free()
 
