## Class that represents a basic popup with button "Go" and "Nope".
extends Control
class_name Tutorial

## Emitted when the "game" has to start.
signal game_start

## Emitted when the "nope" button is pressed.
signal cancel


## Called when "Go" button is pressed.
func _on_go_pressed() -> void:
	game_start.emit()


## Called when the "Nope" button is pressed.
func _on_nope_pressed() -> void:
	cancel.emit()


## Plays the popup audio every time the visibility changes.
func _on_visibility_changed() -> void:
	if self.visible:
		AudioManager.popup()
