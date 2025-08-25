## Slot that contains a Fruit
extends TextureRect

class_name Slot

## Emit when it's been removing from its parent
signal removing


## Animate the enter in the scene-
func _on_tree_entered() -> void:
	self.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.6)
