extends Area2D

@export var speed = 400
@export var damage = 30

func _physics_process(delta: float) -> void:
	
	position.x += speed * delta
