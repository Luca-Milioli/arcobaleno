extends Node

signal play_pressed

func _ready() -> void:
	$TopBar/Text.set_text("")
	$PlayButton/Text.set_text("Rigioca")
	$SiteButton/Text.set_text("Torna al sito")

func _on_play_pressed() -> void:
	self.play_pressed.emit()
