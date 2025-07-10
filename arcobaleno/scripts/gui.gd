extends Control

func _on_correct_fruit(fruit: Item) -> void:
	fruit.disable_area()
	$FeedbackRect/FeedbackLabel.set_text(fruit.get_name().to_upper())
	$FeedbackRect.fade_in_out()
	

func _on_uncorrect_fruit(fruit: Item) -> void:
	fruit.reset()

func _on_group_completed(group: GameLogic.GROUPS) -> void:
	pass

func _on_win() -> void:
	pass
