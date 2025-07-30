extends TextureRect

class_name Slot

signal removing

func _on_tree_entered() -> void:
	self.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.6)
