## Main. It manages transition from a scene to another (menu, gui).
extends Node
class_name Main

## URL of site that it'll be redirected to.
const URL = "https://spreafico.net"


## Makes the background transparent
## Makes game start or connect menu to make it start.
func _ready() -> void:
	get_viewport().size = DisplayServer.window_get_size()
	get_tree().root.transparent_bg = true
	#RenderingServer.set_default_clear_color(Color(0, 0, 0, 0)) # already changed in project settings
	await get_tree().process_frame
	print(get_viewport().size)
	if $SubViewportContainer/SubViewport.has_node("Gui"):
		_on_gui_entered()
	else:
		$SubViewportContainer/SubViewport/StartMenu.play_pressed.connect(_on_menu_play_pressed)


## Called when Gui entered. It connects some signals.
func _on_gui_entered() -> void:
	GameLogic.win.connect(_on_win)
	GameLogic.connect_to_target($SubViewportContainer/SubViewport/Gui)
	$SubViewportContainer/SubViewport/Gui/ResetPopup.game_start.connect(_on_replay)


## Called when start_menu button is pressed. It makes enter gui.
func _on_menu_play_pressed() -> void:  # no more start menu -> unused
	var start_menu = $SubViewportContainer/SubViewport.get_node("StartMenu")
	await start_menu.kill()
	remove_child(start_menu)
	start_menu.queue_free()

	var gui = preload("res://scenes/main_gui/gui.tscn")
	$SubViewportContainer/SubViewport.add_child(gui)
	_on_gui_entered()


## Redirects to the URL.
func _on_site_pressed() -> void:
	if OS.get_name() == "Web":
		var js = Engine.get_singleton("JavaScriptBridge")
		js.call("eval", "window.location.href = '" + URL + "';")
	else:
		get_tree().quit()


## Called when game is finished.
func _on_win() -> void:
	await $SubViewportContainer/SubViewport/Gui.finished

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	await $SubViewportContainer/SubViewport/Gui.kill_self()
	$SubViewportContainer/SubViewport/Gui.queue_free()
	add_child(end_menu)

	end_menu.connect_replay(_on_replay)
	end_menu.site_pressed.connect(_on_site_pressed)


## Called when restart is pressed. Makes the game restart.
func _on_replay() -> void:
	GameLogic.reset_and_restart()
	FruitFactory.reset_and_restart()
	get_tree().reload_current_scene()


## Called when a child is added. It moves FullScreenButton in last position.
func _on_child_entered_tree(node: Node) -> void:
	if has_node("FullScreenButton"):
		move_child.call_deferred($SubViewportContainer/SubViewport/FullScreenButton, -1)
