## Main. It manages transition from a scene to another (menu, gui).
extends Node
class_name Main

## Window of browser. Different from get_window()
var window
## True if this game is running on mobile.
var mobile: bool


## Set mobile attribute and connects some signal of get_window and calculate the top window.
## Makes game start or connect menu to make it start.
func _ready() -> void:
	self.mobile = (
		OS.has_feature("mobile") or OS.has_feature("web_ios") or OS.has_feature("web_android")
	)
	if OS.get_name() == "Web":
		self.window = JavaScriptBridge.get_interface("window").parent
		get_window().focus_entered.connect(_on_window_focus_entered)
		get_window().focus_exited.connect(_on_window_focus_exited)

	if $SubViewportContainer/SubViewport.has_node("Gui"):
		_on_gui_entered()
	else:
		$SubViewportContainer/SubViewport/StartMenu.play_pressed.connect(_on_menu_play_pressed)


## When window is not in background anymore, it resumes the audio.
func _on_window_focus_entered() -> void:
	AudioManager.set_paused(false)


## When window goes in background, it pauses the audio.
func _on_window_focus_exited() -> void:
	AudioManager.set_paused(true)


## Resize viewport as viewportcontainer.
## Checks every frame the screen orientation and stops the game (mobile only).
## DisplayServer.screen_get_orientation() doesn't work.
## Main must be set Process = Always.
## Its direct child must be set Process = Pausable.
func _process(_delta):
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size
	
	if self.mobile:
		if window.matchMedia("(orientation: portrait)").matches:
			$SubViewportContainer/SubViewport/RotateWarning.visible = true
			set_paused(true)
		else:
			$SubViewportContainer/SubViewport/RotateWarning.visible = false
			set_paused(false)


## Put the game and the audio in pause.
func set_paused(paused: bool) -> void:
	if paused != get_tree().paused:
		get_tree().paused = paused
		AudioManager.set_paused(paused)


## Called when Gui entered. It connects some signals.
func _on_gui_entered() -> void:
	GameLogic.win.connect(_on_win)
	GameLogic.connect_to_target($SubViewportContainer/SubViewport/Gui)
	$SubViewportContainer/SubViewport/Gui/ResetPopup.game_start.connect(_on_replay)


## Called when start_menu button is pressed. It makes enter gui.
func _on_menu_play_pressed() -> void:  # no more start menu -> unused
	var start_menu = $SubViewportContainer/SubViewport.get_node("StartMenu")
	await start_menu.kill()
	$SubViewportContainer/SubViewport.remove_child(start_menu)
	start_menu.queue_free()

	var gui = preload("res://scenes/main_gui/gui.tscn")
	$SubViewportContainer/SubViewport.add_child(gui)
	_on_gui_entered()


## URL is the "parent" of the actual URL.
## When "back" button is pressed on menu, calls the URL using javascript eval function.
## if the game is a webexport. Quits the application otherwise.
func _on_site_pressed() -> void:
	if OS.get_name() == "Web":
		var URL = JavaScriptBridge.call(
			"eval", "top.location.href.split('/').slice(0, -2).join('/');"
		)
		JavaScriptBridge.call("eval", "top.location.href = '" + URL + "';")
	else:
		get_tree().quit()


## Called when game is finished.
func _on_win() -> void:
	await $SubViewportContainer/SubViewport/Gui.finished

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	await $SubViewportContainer/SubViewport/Gui.kill_self()
	$SubViewportContainer/SubViewport/Gui.queue_free()
	$SubViewportContainer/SubViewport.add_child(end_menu)

	end_menu.connect_replay(_on_replay)
	end_menu.site_pressed.connect(_on_site_pressed)


## Called when restart is pressed. Makes the game restart.
func _on_replay() -> void:
	GameLogic.reset_and_restart()
	FruitFactory.reset_and_restart()
	get_tree().reload_current_scene()


## Called when a child is added. It moves FullScreenButton in last position.
func _on_child_entered_tree(node: Node) -> void:
	if $SubViewportContainer/SubViewport.has_node("FullScreenButton"):
		$SubViewportContainer/SubViewport.move_child.call_deferred(
			$SubViewportContainer/SubViewport/FullScreenButton, -1
		)
