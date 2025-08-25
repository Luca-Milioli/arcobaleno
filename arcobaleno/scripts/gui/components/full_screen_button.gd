extends TextureButton


func _toggle_fullscreen() -> void:  # return ture if it sets fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_pressed() -> void:
	_toggle_fullscreen()
	await get_tree().process_frame
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		var hover = preload("res://art/graphics/buttons/FullscreenHover.png")
		set("texture_normal", preload("res://art/graphics/buttons/Fullscreen.png"))
		set("texture_hover", hover)
		set("texture_pressed", hover)
	else:
		var hover = preload("res://art/graphics/buttons/FullscreenHover.png")
		set("texture_normal", preload("res://art/graphics/buttons/Fullscreen.png"))
		set("texture_hover", hover)
		set("texture_pressed", hover)
