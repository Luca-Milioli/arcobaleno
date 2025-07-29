extends Control

signal game_start
signal cancel


func _on_go_pressed() -> void:
	game_start.emit()


func _on_nope_pressed() -> void:
	cancel.emit()


func _on_visibility_changed() -> void:
	if self.visible:
		AudioManager.popup()
