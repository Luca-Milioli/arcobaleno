extends Node

const URL = "https://spreafico.net"


func _ready() -> void:
	if has_node("Gui"):
		_on_gui_entered()
	else:
		$StartMenu.play_pressed.connect(_on_menu_play_pressed)


func _on_gui_entered() -> void:
	GameLogic.win.connect(_on_win)
	GameLogic.connect_to_target($Gui)
	$Gui/ResetPopup.game_start.connect(_on_replay)


func _on_menu_play_pressed() -> void:  # no more start menu -> unused
	var start_menu = get_node("StartMenu")
	await start_menu.kill()
	remove_child(start_menu)
	start_menu.queue_free()

	var gui = preload("res://scenes/main_gui/gui.tscn")
	add_child(gui)
	_on_gui_entered()


func _on_site_pressed() -> void:
	if OS.get_name() == "Web":
		var js = Engine.get_singleton("JavaScriptBridge")
		js.call("eval", "window.location.href = '" + URL + "';")
	else:
		get_tree().quit()


func _on_win() -> void:
	await $Gui.finished

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	await $Gui.kill_self()
	$Gui.queue_free()
	add_child(end_menu)

	end_menu.connect_replay(_on_replay)
	end_menu.site_pressed.connect(_on_site_pressed)


func _on_replay() -> void:
	GameLogic.reset_and_restart()
	FruitFactory.reset_and_restart()
	get_tree().reload_current_scene()
