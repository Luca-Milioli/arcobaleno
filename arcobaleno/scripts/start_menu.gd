extends Control

signal play_pressed

func _ready() -> void:
	$PlayButton/Text.set_text("Gioca")

func _on_play_pressed() -> void:
	self.play_pressed.emit()
