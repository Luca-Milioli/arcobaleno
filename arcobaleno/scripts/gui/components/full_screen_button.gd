## Manages FullScreen or Windowed Mode.
extends TextureButton
class_name FullScreenButton


## If this game is running on a Web browser on mobile, this button will be removed.
func _ready() -> void:
	if OS.has_feature("web_ios") or OS.has_feature("web_android"):
		queue_free()


## Set fullscreen if it's windowed and possible. If it's fullscreen it sets windowed.
func _toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


## Called when button is pressed. Toggles window mode.
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
