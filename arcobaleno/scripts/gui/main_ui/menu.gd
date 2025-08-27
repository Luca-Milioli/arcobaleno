## Script that manages every game menu (start menu, win menu, lose menu, ...).
extends CommonUI

## Emitted when the "play" button is pressed.
signal play_pressed
## Emitted when the "back" button is pressed.
signal site_pressed


## Called from main only on End_menu. It enables the "play again" functionality.
func connect_replay(method: Callable) -> void:  # chiamato dal main solo su end_menu
	self.play_pressed.connect(method)
	$ResetPopup.game_start.connect(method)


## Emits the play_pressed signal.
func _on_play_pressed() -> void:
	self.play_pressed.emit()


## Emits the site_pressed signal.
func _on_site_pressed() -> void:
	self.site_pressed.emit()


## Checks what tyoe of menu it is (main menu or end menu) and plays the correct audio
## and animation.
func _on_tree_entered() -> void:
	if get_name() == "EndMenu":
		AudioManager.win()
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 1.3)


## Fades out itself.
func kill():
	var tween = create_tween()
	self.modulate.a = 1.0
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	await tween.finished
