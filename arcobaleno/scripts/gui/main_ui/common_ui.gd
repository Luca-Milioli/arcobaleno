## Class that implements some common features that some gui component may use. This root scene must have topbar and resetpopup scenes in order to make this script work.
extends Node
class_name CommonUI


## Called when retry button of topbar is pressed. It disables every other button and
## spawns the reset popup.
func _on_top_bar_retry_pressed() -> void:
	$ResetPopup.visible = true
	Utils.recursive_disable_buttons(self, true)
	await fade_in($ResetPopup)
	Utils.recursive_disable_buttons($ResetPopup, false)


## Called when the "cancel" button is pressed on reset popup. It enables every other button
## and despawn the reset popup.
func _on_reset_popup_cancel() -> void:
	Utils.recursive_disable_buttons($ResetPopup, true)
	await fade_out($ResetPopup)
	Utils.recursive_disable_buttons(self, false)
	$ResetPopup.visible = false


## General fade, mainly used for scene transition.
## it's private and should be called from public methods fade in and fade out.
func _fade(node: Node, final_node: float, final_gui: float, time = 0.6) -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(node, "modulate:a", final_node, time).set_ease(Tween.EASE_OUT)
	if self != node:  # if self and node are the same node, this animation shouldnt be called
		tween.tween_property(self, "modulate:a", final_gui, time).set_ease(Tween.EASE_OUT)
	await tween.finished


## Fade in transition.
func fade_in(node: Node, modulate: float = 1.0, other_modulate: float = 0.2) -> void:
	node.modulate.a = 0
	await _fade(node, modulate, other_modulate)


## Fade out transition.
func fade_out(node: Node, time = 0.6) -> void:
	await _fade(node, 0.0, 1.0, time)
