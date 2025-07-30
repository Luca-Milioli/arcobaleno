extends HBoxContainer

signal retry_pressed
signal audio_pressed


func _on_audio_button_pressed() -> void:
	$AudioButton.visible = not $AudioButton.visible
	$NextAudioButton.visible = not $NextAudioButton.visible

	# swap node names so that "AudioButton" is always the current one
	var audio_btn = $AudioButton
	var next_audio_btn = $NextAudioButton

	var name1 = audio_btn.name
	var name2 = next_audio_btn.name

	# nodes must not have the same name, so i need to rename it before swap
	audio_btn.set_name("tmp name")
	next_audio_btn.set_name(name2)
	audio_btn.set_name(name1)

	self.audio_pressed.emit()


func _on_retry_button_pressed() -> void:
	self.retry_pressed.emit()


func text_first_entrance() -> void:
	$Text.modulate.a = 0.0
	$Text.visible = true
	var tween = create_tween()
	tween.tween_property($Text, "modulate:a", 1.0, 0.5)
