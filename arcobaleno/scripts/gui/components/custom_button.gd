extends BaseButton


func _on_pressed() -> void:
	AudioManager.tap()


func _on_visibility_changed() -> void:
	if self.visible:
		self.modulate.a = 0
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)
