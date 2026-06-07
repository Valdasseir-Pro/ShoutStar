extends Node

const SAVE_PATH = "user://save_data.dat"
const  INPUT_SAVE_PATH = "user://controls.cfg"

var best_score: int = 0
var last_score: int = 0

var audio_volume: Dictionary = {}


func _ready() -> void:
	load_game()
	load_input_settings()

func save_game() -> void:
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		
		var data = {
			"best_score": best_score,
			"last_score": last_score,
			"audio_volume": audio_volume,
			"fullscreen_mode": DisplayServer.window_get_mode(),
			"language": TranslationServer.get_locale(),
		}
		
		file.store_var(data)
		file.close()
		
func load_game() -> void:
	
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	var data = file.get_var()
	file.close()
	
	if data is Dictionary:
		best_score = data.get("best_score", 0)
		last_score = data.get("last_score", 0)
		audio_volume = data.get("audio_volume", {})
		DisplayServer.window_set_mode(data.get("fullscreen_mode", DisplayServer.WINDOW_MODE_WINDOWED))
		TranslationServer.set_locale(data.get("language", TranslationServer.get_locale()))
		
func update_score(final_score: int) -> void:
	
	last_score = final_score
	
	if final_score > best_score:
		best_score = final_score
		
	save_game()
	
func update_sound_volume(sound: String, volume: float) -> void:
	
	audio_volume[sound] = volume
	
	save_game()
	
func save_input_settings() -> void:
	
	var config = ConfigFile.new()
	
	for action in InputMap.get_actions():
		
		if action.begins_with("ui_"):
			continue
			
		var events = InputMap.action_get_events(action)
		
		if events.size() > 0:
			
			var event = events[0]
			
			if event is InputEventKey:
				
				config.set_value("Controls", action, event.keycode)
				
	config.save(INPUT_SAVE_PATH)
	
func load_input_settings() -> void:
	
	var config = ConfigFile.new()
	var error = config.load(INPUT_SAVE_PATH)
	
	if error != OK:
		return
		
	if config.has_section("Controls"):
		
		for action in config.get_section_keys("Controls"):
			
			if InputMap.has_action(action):
				
				InputMap.action_erase_events(action)
				
				var saved_keycode = config.get_value("Controls", action)
				
				var new_event = InputEventKey.new()
				new_event.keycode = saved_keycode
				
				InputMap.action_add_event(action, new_event)
				
func reset_input_settings() -> void:
	
	InputMap.load_from_project_settings()
	
	if FileAccess.file_exists(INPUT_SAVE_PATH):
		DirAccess.remove_absolute(INPUT_SAVE_PATH)
		
	get_tree().call_group("remap_buttons", "_update_button_text")
	
