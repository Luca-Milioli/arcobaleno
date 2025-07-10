extends Node

func _on_menu_play_pressed() -> void:
	var menu = get_node("Menu")
	remove_child(menu)
	
	var gui = preload("res://scenes/gui.tscn").instantiate()
	GameLogic.connect_to_target(gui)
	add_child(gui)
