## Class that represents the topbar of display. It contains retry button, audio button
## and text.
extends HBoxContainer
class_name TopBar

## Emitted when user presses retry, so the game can restart.
signal retry_pressed


## Swaps audio and audio muted when the game starts and audio is muted.
## By default audio is not muted, but in browsers audio is muted at the beginning.
func _ready():
	if AudioManager.is_audio_muted():
		_swap_audio_buttons()


## Swaps the audio muted and not muted buttons. Called every time the user toggles the audio.
func _swap_audio_buttons():
	$AudioButton.visible = not $AudioButton.visible
	$NextAudioButton.visible = not $NextAudioButton.visible

	# swap node names so that "AudioButton" is always the current one
	var audio_btn = $AudioButton
	var next_audio_btn = $NextAudioButton

	var name1 = audio_btn.name
	var name2 = next_audio_btn.name

	# nodes must not have the same name, so i need to rename it before swap.
	audio_btn.set_name("tmp name")
	next_audio_btn.set_name(name2)
	audio_btn.set_name(name1)


## Called when user presses on audio button. It toggles audio and swaps button images.
func _on_audio_button_pressed() -> void:
	_swap_audio_buttons()
	AudioManager.toggle_audio()


## Called when the user presses the retry button.
func _on_retry_button_pressed() -> void:
	self.retry_pressed.emit()


## Animation played in the first entrance of the text.
func text_first_entrance() -> void:
	$Text.modulate.a = 0.0
	$Text.visible = true
	var tween = create_tween()
	tween.tween_property($Text, "modulate:a", 1.0, 0.5)
