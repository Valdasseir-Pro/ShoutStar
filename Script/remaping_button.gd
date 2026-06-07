extends Button

@export var action_name:  String

var is_listening: bool = false

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("remap_buttons")
	_update_button_text()
	
func _update_button_text() -> void:
	
	var events = InputMap.action_get_events(action_name)
	
	if events.size() > 0:
		text = events[0].as_text().replace(" (Physical)", "")
	else:
		text = "Aucune touche"
		

func _pressed() -> void:
	
	if not is_listening:
		is_listening = true
		text = "... Appuie sur une touche ..."
		
		release_focus()
		
func _unhandled_input(event: InputEvent) -> void:
	
	if not is_listening:
		return
		
	if event is InputEventKey and event.is_pressed():
		
		InputMap.action_erase_events(action_name)
		
		InputMap.action_add_event(action_name, event)
		
		is_listening = false
		_update_button_text()
		
		get_viewport().set_input_as_handled()
		
		GlobalFile.save_input_settings()
