extends HSlider

@export var audio_bus: String
var audio_bus_index
var value_save: float

func _ready() -> void:
	var sound = GlobalFile.audio_volume.get(audio_bus, 1)
	audio_bus_index = AudioServer.get_bus_index(audio_bus)
	AudioServer.set_bus_volume_db(audio_bus_index, sound)
	value = sound
	


@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_index, db)
	
	
@warning_ignore("unused_parameter", "shadowed_variable_base_class")
func _on_drag_ended(value_changed: bool) -> void:
	GlobalFile.update_sound_volume(audio_bus, value)
