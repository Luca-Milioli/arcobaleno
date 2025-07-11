extends Node

var menu: Control
var gui: Control

func _ready() -> void:
	menu = get_node("Menu")

func _on_menu_play_pressed() -> void:
	remove_child(menu)
	
	gui = preload("res://scenes/gui.tscn").instantiate()
	GameLogic.connect_to_target(gui)
	add_child(gui)
	
	GameLogic.win.connect(_on_win)

func _on_win() -> void:
	await gui.finished
	
	menu.end_game()
	
	menu.play_pressed.disconnect(_on_menu_play_pressed)
	menu.play_pressed.connect(_on_end_menu_play_pressed)
	
	remove_child(gui)
	gui.queue_free()
	add_child(menu)
	
	GameLogic.reset()

func _on_end_menu_play_pressed() -> void:
	get_tree().reload_current_scene()
