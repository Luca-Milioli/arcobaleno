extends Control

signal clicked
signal finished

func _on_correct_fruit(fruit: Item) -> void:
	fruit.disable_area()
	fruit.set_dropped(true)
	$FeedbackRect/FeedbackLabel.set_text(fruit.get_name().to_upper())
	$FeedbackRect.fade_in_out()
	$HBoxContainer/ItemSpawner.spawn_and_shift(fruit)

func _on_uncorrect_fruit(fruit: Item) -> void:
	fruit.reset()

func _on_group_completed(group: GameLogic.GROUPS) -> void:
	$GroupRect/GroupLabel.set_text("Gruppo " + GameLogic.GROUPS.keys()[group])
	await $GroupRect.fade_in()
	await self.clicked
	await $GroupRect.fade_out()
	self.finished.emit()

func _on_gui_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released()):
		self.clicked.emit()
