extends CanvasLayer

@onready var tween_red: Tween
@onready var heart_container: Node = $Control/Heart
@onready var texture_rect: TextureRect = $Control/TextureRect

func _ready() -> void:
	
	$Control/TextureRect.hide()

func update_health(health) -> void:
	
	var hearts = heart_container.get_children()
	
	for i in range(hearts.size()):
		
		#si la condition i < health est vrai, alors hearts de i visible est definie sur vrai
		hearts[i].visible = (i < health)

	
	if health == 1:
		tween_red_start()
	else:
		tween_red_stop()

func tween_red_start():
	
	texture_rect.show()
	
	if tween_red and tween_red.is_running():
		return
		
	tween_red = create_tween().set_loops()
	
	tween_red.tween_callback($"Control/Death signal".play)
	
	tween_red.tween_property(texture_rect,"modulate:a", 0.8, 0.5)
	tween_red.tween_property(texture_rect,"modulate:a", 0.1, 0.5)
	
	
func tween_red_stop() -> void:
	if tween_red:
		tween_red.kill()
		texture_rect.hide()
