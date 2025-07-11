extends Control

signal play_pressed

func _on_play_pressed() -> void:
	self.play_pressed.emit()

func end_game() -> void:
	var background = preload("res://art/graphics/white_king.png")
	if(background):
		$Background.texture = background
