extends Area2D

@export var speed = 400
@export_range(30, 600, 30) var life = 150
@export var score_kill = 5

@onready var proj_scene = preload("res://scene/proj.tscn")

var direction = Vector2.ZERO

var move = false

func _physics_process(delta: float) -> void:
	
	if move:
		
		position += direction * speed * delta
		

func _on_timer_timeout() -> void:
	
	var player = get_tree().get_first_node_in_group("Player")
	
	direction = global_position.direction_to(player.global_position)
	
	move = true
	


func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Missile"):
		
		life -= area.damage
		
		var proj = proj_scene.instantiate()
		proj.color = Color.ORANGE
		proj.initial_velocity_min *= -1
		proj.initial_velocity_max *= -1
		add_child(proj)
		
		var pos = area.global_position
		
		proj.global_position = pos
		
		proj.start()
		
		area.queue_free()
		
		if life <= 0:
			
			var game = get_tree().get_first_node_in_group("Game")
			game.ennemie_death(pos)
			game.add_score(score_kill)
			
			queue_free()

func stop_ennemie() -> void:
	
	$Timer.stop()
