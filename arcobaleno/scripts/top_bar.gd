extends HBoxContainer

signal retry_pressed
signal audio_pressed

func _on_audio_button_pressed() -> void:
	self.audio_pressed.emit()

func _on_retry_button_pressed() -> void:
	self.retry_pressed.emit()
