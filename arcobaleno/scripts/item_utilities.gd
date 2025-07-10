extends Node2D

var dragging : bool
var drag_offset : Vector2

func _ready() -> void:
	self.dragging = false
	
func get_pixels() -> Vector2:
	var sprite = $ItemSprite
	var tex_size = sprite.region_enabled if sprite.region_rect.size else sprite.texture.get_size()
	var global_scale = self.global_transform.get_scale()
	return tex_size * global_scale

func set_image(img: String):
	#print("LOADING IMAGE: "+img)
	$ItemSprite.set_texture(load(img))

func get_image():
	return $ItemSprite.get_texture().resource_path
	
func _on_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		self.dragging = true
		self.drag_offset = self.global_position - event.position
		get_viewport().set_input_as_handled()

func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Ferma il dragging
		dragging = false

func _process(delta):
	if dragging:
		self.global_position = get_viewport().get_mouse_position() + self.drag_offset
