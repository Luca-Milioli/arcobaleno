extends TextureRect

var tween : Tween
	
func animate(fade_in: bool, timing: float = 1.0, delay: float = 0) -> void:
	self.tween = create_tween()
	self.tween.tween_property(self, "modulate:a", int(fade_in), timing).set_delay(delay).set_ease(Tween.EASE_OUT_IN)
	
func fade_in_out() -> void:
	if self.tween and self.tween.finished:
		self.tween.kill()
		
	self.visible = true
	animate(true, 0.4, 0.1)
	await self.tween.finished

	animate(false, 1.0, 1.4)
	await self.tween.finished
	self.visible = false

func fade_in() -> void:
	self.visible = true
	animate(true, 1.0, 0.1)
	await self.tween.finished

func fade_out() -> void:
	animate(false, 1.4)
	await self.tween.finished
	self.visible = false
