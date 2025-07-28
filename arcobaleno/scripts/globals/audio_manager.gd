extends Node


func _ready() -> void:
	$MainOst.play()


func toggle_audio():
	for i in AudioServer.get_bus_count():
		var is_muted = AudioServer.is_bus_mute(i)
		AudioServer.set_bus_mute(i, not is_muted)


func is_audio_muted():
	for i in AudioServer.get_bus_count():
		if not AudioServer.is_bus_mute(i):
			return false
	return true


func reset():
	$MainOst.play(0.0)


func stop():
	$MainOst.stop()


func win():
	$Win.play()


func lose():
	$Lose.play()


func correct():
	$CorrectAnswer.play()


func wrong():
	$WrongAnswer.play()
