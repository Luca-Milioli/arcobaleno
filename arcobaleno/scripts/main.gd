extends Node

func _on_tree_entered() -> void:
	GameLogic.win.connect(_on_win)
	GameLogic.connect_to_target($Gui)
	$Gui/ResetPopup.game_start.connect(_on_replay)

func _on_menu_play_pressed() -> void:	# no more start menu -> unused
	var start_menu = get_node("StartMenu")
	remove_child(start_menu)
	start_menu.queue_free()

func _on_win() -> void:
	await $Gui.finished
	
	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()
	
	$Gui.queue_free()
	add_child(end_menu)
	
	end_menu.connect_replay(_on_replay)

func _on_replay() -> void:
	GameLogic.reset()
	get_tree().reload_current_scene()
