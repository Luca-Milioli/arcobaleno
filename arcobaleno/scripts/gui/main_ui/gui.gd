## View of the game. Manages Fruit drag, FruitContainer and others components.
extends CommonUI

class_name Gui

## Emitted when game is finished.
signal finished


## Scales rainbow size.
func _ready() -> void:
	var scale = $Rainbow.size / get_viewport().get_visible_rect().size
	_scale_collisions_shape(scale)


## Scales every Area2D.
func _scale_collisions_shape(scale: Vector2) -> void:
	$Rainbow/WhiteArea.scale = scale
	$Rainbow/OrangeArea.scale = scale
	$Rainbow/GreenArea.scale = scale
	$Rainbow/BlueArea.scale = scale
	$Rainbow/RedArea.scale = scale


## Animates the exit.
func kill_self() -> void:
	await super.fade_out(self)


## Connects fruits signals when they're ready and it enables arrows.
func _on_fruit_ready() -> void:
	Utils.recursive_disable_buttons($LeftArrow, false)
	Utils.recursive_disable_buttons($RightArrow, false)

	for slot in $FruitContainer.get_children():
		if slot is Slot:
			slot.connect("removing", _add_texture_rect)
			for fruit in slot.get_children():
				if fruit is Fruit:
					fruit.connect("start_drag", _add_texture_rect)
					fruit.connect("end_drag", _on_end_drag.bind(fruit))


## Adds a Fruit when it's dragging.
func _add_texture_rect(texture_rect: TextureRect, position: Vector2, size: Vector2) -> void:
	add_child(texture_rect)
	texture_rect.set_size(size)
	texture_rect.set_global_position(position)


## Removes a Fruit from its children when it finishes the drag.
func _on_end_drag(fruit: Fruit) -> void:
	remove_child(fruit)


## Called when fruit is correctly placed. Adds it to Rainbow.
func _on_correct_fruit(fruit: Fruit) -> void:
	fruit.set_dropped(true)

	var fruit_size = fruit.size
	var fruit_pos = fruit.global_position

	$FruitContainer.moved(fruit)

	_on_end_drag(fruit)
	$Rainbow.add_child(fruit)

	fruit.global_position = fruit_pos
	$Rainbow.resize_fruits(fruit_size)


## Called when fruit is wrongly placed. It brings it back to its original position.
func _on_uncorrect_fruit(fruit: Fruit) -> void:
	fruit.reset()


## Called when a group is completed. It makes appear its feedback.
func _on_group_completed(group: GameLogic.GROUPS) -> void:
	if $FeedbackColor.visible:
		$FeedbackTimer.stop()
		await _on_feedback_timer_timeout()

	$FeedbackColor.set_feedback_text(FruitFactory.get_feedback(group))

	$FeedbackColor.visible = true

	$FeedbackTimer.start()

	await $FeedbackTimer.timeout

	self.finished.emit()


## Called when a Feedback has to fade out.
func _on_feedback_timer_timeout() -> void:
	await $FeedbackColor.fade_out()
	$FeedbackColor.visible = false


## Animates enter.
func _on_tree_entered() -> void:
	await super.fade_in($".")

	appear_objects()


## Animates enter if there's tutorial.
func _on_tree_entered_with_tutorial() -> void:  # not connected bc no tutorial
	Utils.recursive_disable_buttons(self, true)

	await super.fade_in($".")

	$TutorialPopup.visible = true
	await super.fade_in($TutorialPopup)

	Utils.recursive_disable_buttons($TutorialPopup, false)


## Starts game if tutorial popup is pressed.
func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons($TutorialPopup, true)
	await super.fade_out($TutorialPopup)

	appear_objects()

	$TutorialPopup.queue_free()

	Utils.recursive_disable_buttons(self, false)


## Makes its children visible. They will be animated.
func appear_objects():
	$TopBar.text_first_entrance()
	$Rainbow.visible = true

	if not $FruitContainer.are_enough_slot():
		$LeftArrow.visible = true
		$RightArrow.visible = true

	$FruitContainer.visible = true


## Called when left arrow is pressed. Fruits will be shift to left.
func _on_left_arrow_pressed() -> void:
	$FruitContainer.shift_left()


## Called when right arrow is pressed. Fruits will be shift to right.
func _on_right_arrow_pressed() -> void:
	$FruitContainer.shift_right()


## Called when every slot can be visible. It fades out and frees the arrows.
func _on_enough_slot() -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($LeftArrow, "modulate:a", 0, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property($RightArrow, "modulate:a", 0, 1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	$LeftArrow.queue_free()
	$RightArrow.queue_free()
