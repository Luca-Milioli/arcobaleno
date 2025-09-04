## Signleton that manages sounds and it can mute or unmute.
extends Node
class_name AudioManagerScript


## _ready function: starts ost.
func _ready() -> void:
	$MainOst.play()


## Pause the audio if paused is true. Resumes it otherwise.
func set_paused(paused: bool) -> void:
	AudioManager.get_tree().paused = paused


## Switches audio from off to on or from on to off.
func toggle_audio():
	for i in AudioServer.get_bus_count():
		var is_muted = AudioServer.is_bus_mute(i)
		AudioServer.set_bus_mute(i, not is_muted)


## Getter for audio, returns true if muted, false otherwise .
func is_audio_muted():
	for i in AudioServer.get_bus_count():
		if not AudioServer.is_bus_mute(i):
			return false
	return true


## Resets main ost.
func reset():
	$MainOst.play(0.0)


## Stops main ost.
func stop():
	$MainOst.stop()


## Plays win audio.
func win():
	$Win.play()


## Plays lose audio.
func lose():
	$Lose.play()


## Plays correct answer audio.
func correct():
	$CorrectAnswer.play()


## Plays wrong answer audio.
func wrong():
	$WrongAnswer.play()


## Plays tap audio.
func tap():
	$Tap.play()


## Plays popup audio.
func popup():
	$Popup.play()
