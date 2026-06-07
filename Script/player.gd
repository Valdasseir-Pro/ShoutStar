extends CharacterBody2D

@export var speed = 200
@export var acceleration = 5000
@export var friction = 1200
@export var fire_rate := 10

@onready var misile_scene = preload("res://scene/missile.tscn")
@onready var shoot_particle_scene = preload("res://scene/proj.tscn")
@onready var explosion_scene = preload("res://scene/explosion_particle.tscn")
@onready var ui = get_tree().get_first_node_in_group("UI")

signal player_died

var cooldown = 0
var shooter = 1
var life = 3

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("Gauche", "Droite"),
		Input.get_axis("Haut", "Bas")
	).normalized()
	var target_velocity = direction * speed

	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(
		target_velocity,
		acceleration * delta)
			
	else:
		velocity = velocity.move_toward(
			target_velocity,
			friction * delta)

	move_and_slide()
	
	cooldown -= delta
	
	if Input.is_action_pressed("Shoot") and cooldown <= 0:
		
		shoot()
		cooldown = 1.0 / fire_rate
		
	if Input.is_action_just_pressed("Shoot"):
		
		speed /= 2
		
	if Input.is_action_just_released("Shoot"):
		
		speed *= 2
		
		
func shoot():
	
	var missile = misile_scene.instantiate()
	var shoot_particle = shoot_particle_scene.instantiate()
	shoot_particle.color = Color.RED
	
	if shooter == 1:
		
		missile.global_position = $GunPoint1.global_position
		
		add_child(shoot_particle)
		shoot_particle.global_position = $GunPoint1.global_position
		
		shoot_particle.start()
		
		shooter = 2
		
	else:
		
		missile.global_position = $GunPoint2.global_position
		
		add_child(shoot_particle)
		shoot_particle.global_position = $GunPoint2.global_position
		
		shoot_particle.start()
		
		shooter = 1
	
	if life <= 1:
		missile.damage = 50
		
	get_parent().add_child(missile)
	
	$ShootSound.play()


func _on_detecte_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Ennemie") and life > 0:
		life -= 1
		
		var explosion = explosion_scene.instantiate()
		add_child(explosion)
		explosion.global_position = area.global_position
		explosion.start()
		
		area.queue_free()
		$Damage.play()
		ui.update_health(life)
		
		if life <= 0:
		
			player_died.emit()
		
	elif area.is_in_group("Ennemie") and life <= 0:
		
		area.queue_free()
		
		
func _on_trust_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Ennemie"):
		area.queue_free()
