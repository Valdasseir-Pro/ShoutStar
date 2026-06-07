extends OptionButton

var locales: PackedStringArray = []

func _ready() -> void:
	clear()
	
	locales = TranslationServer.get_loaded_locales()
	
	var original_locale = TranslationServer.get_locale()
	
	for locale in locales:
		TranslationServer.set_locale(locale)
		var native_name = tr("KEY_LANGUAGE_NAME")
		add_item(native_name)
		
	TranslationServer.set_locale(original_locale)
	
	_selected_current_language(original_locale)


func _selected_current_language(current_locale: String) -> void:
	
	var index = locales.find(current_locale)
	
	if index == -1:
		index = locales.find(current_locale.left(2))
		
	if index != -1:
		select(index)
	else:
		select(0)


func _on_language_selected(index: int) -> void:
	
	TranslationServer.set_locale(locales[index])
