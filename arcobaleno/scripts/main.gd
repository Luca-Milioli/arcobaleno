extends Node

var gui: Control

func _on_menu_play_pressed() -> void:
	var start_menu = get_node("StartMenu")
	remove_child(start_menu)
	start_menu.queue_free()
	
	gui = preload("res://scenes/gui.tscn").instantiate()
	GameLogic.connect_to_target(gui)
	
	add_child(gui)
	
	GameLogic.win.connect(_on_win)

func _on_win() -> void:
	await gui.finished
	
	var end_menu = preload("res://scenes/end_menu.tscn").instantiate()
	
	remove_child(gui)
	
	add_child(end_menu)
	gui.queue_free()
	
	end_menu.play_pressed.connect(_on_end_menu_play_pressed)

func _on_end_menu_play_pressed() -> void:
	GameLogic.reset()
	get_tree().reload_current_scene()

func _on_audio_pressed() -> void:
	pass # Replace with function body.

func _on_retry_pressed() -> void:
	pass # Replace with function body.
