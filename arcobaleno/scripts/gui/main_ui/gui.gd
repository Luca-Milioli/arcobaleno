extends CommonUI

signal finished


func _ready() -> void:
	var scale = $Rainbow.size / get_viewport().get_visible_rect().size
	_scale_collisions_shape(scale)


func _scale_collisions_shape(scale: Vector2) -> void:
	$Rainbow/WhiteArea.scale = scale
	$Rainbow/OrangeArea.scale = scale
	$Rainbow/GreenArea.scale = scale
	$Rainbow/BlueArea.scale = scale
	$Rainbow/RedArea.scale = scale


func kill_self() -> void:
	await super.fade_out(self)


func _on_fruit_ready() -> void:
	for slot in $FruitContainer.get_children():
		if slot is Slot:
			slot.connect("removing", _add_texture_rect)
			for fruit in slot.get_children():
				if fruit is Fruit:
					fruit.connect("start_drag", _add_texture_rect)
					fruit.connect("end_drag", _on_end_drag.bind(fruit))


func _add_texture_rect(texture_rect: TextureRect, position: Vector2, size: Vector2) -> void:
	add_child(texture_rect)
	texture_rect.set_size(size)
	texture_rect.set_global_position(position)


func _on_end_drag(fruit: Fruit) -> void:
	remove_child(fruit)


func _on_correct_fruit(fruit: Fruit) -> void:
	fruit.set_dropped(true)

	var fruit_size = fruit.size
	var fruit_pos = fruit.global_position

	$FruitContainer.moved(fruit)

	_on_end_drag(fruit)
	$Rainbow.add_child(fruit)

	fruit.global_position = fruit_pos
	$Rainbow.resize_fruits(fruit_size)


func _on_uncorrect_fruit(fruit: Fruit) -> void:
	fruit.reset()


func _on_group_completed(group: GameLogic.GROUPS) -> void:
	Utils.recursive_disable_buttons(self, true)
	$FruitContainer.disable_fruits(
		$FruitContainer.get_children().filter(func(c): return c is Slot), true
	)

	await $FruitContainer.tween_finished

	$FeedbackColor/Advice.set_text(FruitFactory.get_feedback(group))
	$FruitContainer.disable_fruits($FruitContainer.get_children(), true)  # before tween finished are enabled again

	$FeedbackColor.visible = true
	await super.fade_in($FeedbackColor)
	Utils.recursive_disable_buttons($FeedbackColor, false)

	await $FeedbackColor.game_start

	await super.fade_out($FeedbackColor)
	$FeedbackColor.visible = false
	Utils.recursive_disable_buttons(self, false)
	$FruitContainer.disable_fruits(
		$FruitContainer.get_children().filter(func(c): return c is Slot), false
	)

	self.finished.emit()


func _on_tree_entered() -> void:
	super.fade_in($".")
	
	appear_objects()

func _on_tree_entered_with_tutorial() -> void:  # not connected bc no tutorial
	Utils.recursive_disable_buttons(self, true)

	await super.fade_in($".")

	$TutorialPopup.visible = true
	await super.fade_in($TutorialPopup)

	Utils.recursive_disable_buttons($TutorialPopup, false)


func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons($TutorialPopup, true)
	await super.fade_out($TutorialPopup)
	
	appear_objects()
	
	$TutorialPopup.queue_free()

	Utils.recursive_disable_buttons(self, false)


func appear_objects():
	$TopBar.text_first_entrance()
	$Rainbow.visible = true
	$LeftArrow.visible = true
	$RightArrow.visible = true
	$FruitContainer.visible = true


func _on_left_arrow_pressed() -> void:
	$FruitContainer.shift_left()


func _on_right_arrow_pressed() -> void:
	$FruitContainer.shift_right()


func _on_enough_slot() -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($LeftArrow, "modulate:a", 0, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property($RightArrow, "modulate:a", 0, 1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	$LeftArrow.queue_free()
	$RightArrow.queue_free()
