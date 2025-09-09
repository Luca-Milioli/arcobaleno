## Class that represent the view of a feedback that appears when you complete a group.
extends Control
class_name FeedbackColor


## Set feedback_text on the label.
func set_feedback_text(feedback_text: String) -> void:
	$Feedback.set_text(feedback_text)


## Plays the popup audio every time it becomes visibile. Also, it fades itself in
## and move from left to center.
func _on_visibility_changed() -> void:
	if self.visible:
		AudioManager.popup()
		
		var final_pos_x = get_parent_area_size().x / 2 - self.size.x / 2
		var tween = create_tween().set_parallel()

		tween.tween_property(self, "modulate:a", 1.0, 1.0)
		tween.tween_property(self, "global_position:x", final_pos_x, 1.0)
		tween.tween_property(get_parent(), "modulate:a", 0.85, 1.0)
		self.modulate.a = 0


## It fades itself out and move from center to right. When it's finished,
## it brings itself back to the left side, ready for the next animation.
func fade_out() -> void:
	var final_pos_x = get_parent_area_size().x - self.size.x
	var tween = create_tween().set_parallel()

	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_property(self, "global_position:x", final_pos_x, 1.0)
	tween.tween_property(get_parent(), "modulate:a", 1.0, 1.0)
	await tween.finished
	
	self.global_position.x = 0
