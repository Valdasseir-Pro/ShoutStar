extends Area2D

@export var entity_scene : PackedScene
@export var difficulty_time_decrease = 0.2
@export var min_timer_difficulty_delay = 0.3

@onready var collision_shape = $CollisionShape2D
@onready var timer: Timer = $"Spawn Timer"

var local_difficulty = 0

func _on_spawn_timer_timeout() -> void:

	if not entity_scene:
		print("Attention : Aucune scène n'a été assignée au Spawner.")
		return

	var entity = entity_scene.instantiate()
	
	entity.global_position = _get_random_global_position()
	
	get_parent().add_child(entity)
	
	_difficulty()

func _get_random_global_position() -> Vector2:
	
	var shape = collision_shape.shape
	var random_offset = Vector2.ZERO

	if shape is RectangleShape2D:
		
		var size = shape.size
		var extents = size / 2.0
		
		random_offset.x = randf_range(-extents.x, extents.x)
		random_offset.y = randf_range(-extents.y, extents.y)
		
	else:
		print("Ce spawner nessessite un RactangleShape2D pour fonctionner")
	
	return collision_shape.global_position + random_offset
	
func _difficulty() -> void:
	
	if owner and "difficulty" in owner:
		
		var difficulty = owner.difficulty
	
		if difficulty != local_difficulty:
			
			if timer.wait_time - difficulty_time_decrease * difficulty <= 0:
				
				timer.wait_time = min_timer_difficulty_delay
				
			else:
		
				timer.wait_time -= difficulty_time_decrease * difficulty
				
			local_difficulty = difficulty
			
	else:
		print("Warning : 'owner' has not 'difficulty' attribut")
		
func stop_spawner() -> void:
	
	$"Spawn Timer".stop()
