extends Control

func _ready() -> void:
	GameLogic.connect_to_target(self)

func _on_correct_fruit(fruit: Item):
	fruit.disable_area()
	$FeedbackLabel.set_text(fruit.get_name().to_upper())
	$FeedbackRect.visible = true
	await get_tree().create_timer(2.0).timeout

func _on_uncorrect_fruit(fruit: Item):
	fruit.reset()
