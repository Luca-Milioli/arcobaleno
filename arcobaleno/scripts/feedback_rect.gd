extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate(fade_in: bool):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", int(!fade_in), 0.7).set_delay(1.5)
	await tween.finished
	
func _on_visibility_changed() -> void:
	if not is_visible():
		self.visible = true
		await animate(false)
		await animate(true)
		
