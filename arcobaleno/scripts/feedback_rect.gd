extends TextureRect

var tween : Tween
	
func animate(fade_in: bool):
	
	var timing = 1.0
	var delay = 1.4
	if fade_in:
		timing = 0.4
		delay = 0.1
	
	self.tween = create_tween()
	self.tween.tween_property(self, "modulate:a", int(fade_in), timing).set_delay(delay).set_ease(Tween.EASE_OUT_IN)
	
func fade_in_out():
	if self.tween and self.tween.finished:
		self.tween.kill()
		
	self.visible = true
	animate(true)
	await self.tween.finished

	animate(false)
	await self.tween.finished
	self.visible = false
