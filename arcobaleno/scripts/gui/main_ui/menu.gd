extends CommonUI

signal play_pressed
signal site_pressed

func connect_replay(method: Callable) -> void: # chiamato dal main solo su end_menu
	self.play_pressed.connect(method)
	$ResetPopup.game_start.connect(method)

func _on_play_pressed() -> void:
	self.play_pressed.emit()


func _on_site_pressed() -> void:
	self.site_pressed.emit()


func _on_tree_entered() -> void:
	if get_name() == "EndMenu":
		AudioManager.win()
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 1.3)

func kill():
	var tween = create_tween()
	self.modulate.a = 1.0
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	await tween.finished
