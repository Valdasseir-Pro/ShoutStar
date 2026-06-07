extends Control

func _ready() -> void:
	$Score/BestScoreBox/Score.text = str(GlobalFile.best_score)
	$Score/LastScoreBox/Score.text = str(GlobalFile.last_score)

func _on_playbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")


func _on_quitbtn_button_down() -> void:
	get_tree().quit()


func _on_optionbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/settings.tscn")
