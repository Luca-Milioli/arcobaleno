## Class that extends the BaseButton and represents a BaseButton with tap sound on press.
extends BaseButton
class_name CustomButton


## Plays the tap audio when the button is pressed.
func _on_pressed() -> void:
	AudioManager.tap()


## Fades in.
func _on_visibility_changed() -> void:
	if self.visible:
		self.modulate.a = 0
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)
