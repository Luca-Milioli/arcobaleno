extends Control

signal play_pressed

func _on_play_pressed() -> void:
	self.play_pressed.emit()
