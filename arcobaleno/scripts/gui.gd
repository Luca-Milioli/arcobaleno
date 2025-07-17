extends Control

signal clicked
signal finished

func _ready() -> void:
	var scale = $Rainbow.size / get_viewport_rect().size
	_scale_collisions_shape(scale)

func _scale_collisions_shape(scale: Vector2) -> void:
	$Rainbow/WhiteArea.scale = scale
	$Rainbow/OrangeArea.scale = scale
	$Rainbow/GreenArea.scale = scale
	$Rainbow/BlueArea.scale = scale
	$Rainbow/RedArea.scale = scale

func _on_correct_fruit(fruit: Fruit) -> void:
	fruit.set_dropped(true)
	#$FeedbackRect/FeedbackLabel.set_text(fruit.get_name().to_upper())
	#$FeedbackRect.fade_in_out()
	
	var fruit_size = fruit.size
	var fruit_pos = fruit.global_position
	
	$FruitFactory.shift(fruit)
	
	$Rainbow.add_child(fruit)
	
	fruit.global_position = fruit_pos
	$Rainbow.resize_fruits(fruit_size)

func _on_uncorrect_fruit(fruit: Fruit) -> void:
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

func _on_audio_pressed() -> void:
	pass # Replace with function body.


func _on_retry_pressed() -> void:
	pass # Replace with function body.
