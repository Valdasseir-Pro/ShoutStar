extends Node2D

var score = 0
var difficulty = 0

@export var difficulty_score = 10
@onready var explosion_scene = preload("res://scene/explosion_particle.tscn")
@onready var player: CharacterBody2D = $CharacterBody2D
@onready var nuke_scene = preload("res://scene/nuke_explosion.tscn")

func _ready() -> void:
	
	player.player_died.connect(_on_game_over)

func _on_timer_timeout() -> void:
	score += 1
	$UI/Control/Label.text = "Score : " + str(score)
	_difficulty()
	
func _difficulty() -> void:
	
	if score % difficulty_score == 0:
		
		difficulty += 1
		
func add_score(points) -> void:
	
	score += points
	
func ennemie_death(pos) -> void:
	
	var explosion = explosion_scene.instantiate()
	add_child(explosion)
	explosion.global_position = pos
	explosion.start()
	$EnnemieDie.play()
	
func _on_game_over() -> void:
	
	$"Score Timer".stop()
	
	GlobalFile.update_score(score)
	
	get_tree().call_group("Spawners", "stop_spawner")
	
	var nuke = nuke_scene.instantiate()
	
	add_child(nuke)
	nuke.global_position = player.global_position
	
	player.queue_free()
	
	get_tree().call_group("Ennemie", "stop_ennemie")
	
	nuke.emitting = true
	nuke.get_node("AudioStreamPlayer").play()
	
	await get_tree().create_timer(1.5).timeout
	
	for ennemie in get_tree().get_nodes_in_group("Ennemie"):
		var pos = ennemie.global_position
		ennemie.queue_free()
		ennemie_death(pos)
		
	await nuke.finished
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://scene/control.tscn")
	
	
	
