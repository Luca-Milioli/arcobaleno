## Manages FullScreen or Windowed Mode.
extends TextureButton
class_name FullScreenButton


## If user is using a mobile device, this button will be removed.
func _ready() -> void:
	var device = ""
	for arg in OS.get_cmdline_args():
		if arg.begins_with("--device="):
			device = arg.split("=")[1]
	
	if device == "mobile":
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


## When button is released, it forces Normal Texture (to fix a bug from tablet and mobile). 
func _on_button_up() -> void:
	set_pressed_no_signal(false)
