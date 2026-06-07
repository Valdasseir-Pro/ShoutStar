extends Area2D

func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Missile") or area.is_in_group("Ennemie"):
		area.queue_free()
