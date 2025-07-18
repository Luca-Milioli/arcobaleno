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

func _on_correct_fruit(fruit: Fruit) -> void:
	fruit.set_dropped(true)
	
	var fruit_size = fruit.size
	var fruit_pos = fruit.global_position
	
	$FruitContainer.moved(fruit)
	
	$Rainbow.add_child(fruit)
	
	fruit.global_position = fruit_pos
	$Rainbow.resize_fruits(fruit_size)

func _on_uncorrect_fruit(fruit: Fruit) -> void:
	fruit.reset()

func _on_group_completed(group: GameLogic.GROUPS) -> void:
	$FeedbackColor/Advice.set_text(FruitFactory.get_feedback(group))
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($FeedbackColor)
	$FeedbackColor.visible = true
	Utils.recursive_disable_buttons($FeedbackColor, false)
	
	await $FeedbackColor.game_start
	
	await super.fade_out($FeedbackColor)
	Utils.recursive_disable_buttons(self, false)
	
	self.finished.emit()

func _on_tree_entered_with_tutorial() -> void:	# not connected bc no tutorial
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($".")
	await super.fade_in($TutorialPopup)
	$TutorialPopup.visible = true
	Utils.recursive_disable_buttons($TutorialPopup, false)
	Utils.recursive_disable_buttons(self, false)

func _on_tutorial_popup_game_start() -> void:
	await super.fade_out($TutorialPopup)
	$TutorialPopup.queue_free()
	Utils.recursive_disable_buttons(self, false)

func _on_tree_entered() -> void:
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 1.3)


func _on_left_arrow_pressed() -> void:
	$FruitContainer.shift_left()


func _on_right_arrow_pressed() -> void:
	$FruitContainer.shift_right()


func _on_enough_slot() -> void:
	$LeftArrow.visible = false
	$RightArrow.visible = false
