extends Node
class_name CommonUI

# root scene must have topbar and resetpopup to extend this script

func _on_top_bar_retry_pressed() -> void:
	$ResetPopup.visible = true
	Utils.recursive_disable_buttons(self, true)
	await fade_in($ResetPopup)
	Utils.recursive_disable_buttons($ResetPopup, false)

func _on_top_bar_audio_pressed() -> void:
	for i in AudioServer.get_bus_count():
		var is_muted = AudioServer.is_bus_mute(i)
		AudioServer.set_bus_mute(i, not is_muted)

func _on_reset_popup_cancel() -> void:
	Utils.recursive_disable_buttons($ResetPopup, true)
	await fade_out($ResetPopup)
	Utils.recursive_disable_buttons(self, false)
	$ResetPopup.visible = false

# this fade should be done for scene transition
# it's private and should be called from public methods fade in and fade out
func _fade(node : Node, final_node : float, final_gui : float) -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(node, "modulate:a", final_node, 0.6).set_ease(Tween.EASE_OUT)
	if self != node: # if self and node are the same node, this animation shouldnt be called
		tween.tween_property(self, "modulate:a", final_gui, 0.6).set_ease(Tween.EASE_OUT)
	await tween.finished

func fade_in(node : Node) -> void:
	await _fade(node, 1.2, 0.2)

func fade_out(node : Node) -> void:
	await _fade(node, 0.0, 1.0)
