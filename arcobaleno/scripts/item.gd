extends Node2D

class_name Item

var dragging : bool
var drag_offset : Vector2
var start_pos : Vector2
var _dropped : bool
var _fruit: String
var _group: GameLogic.GROUPS

func _ready() -> void:
	self.dragging = false
	self._dropped = false

func set_dropped(dropped: bool):
	self._dropped = dropped

func is_dropped():
	return self._dropped
	
func setup(image: String, spawn_position: Vector2):
	set_image(image)
	set_name(image.get_basename().get_file())
	if(image.get_basename().get_file()[0] <= "c"):
		set_group(0)
	elif(image.get_basename().get_file()[0] <= "f"):
		set_group(1)
	elif(image.get_basename().get_file()[0] <= "m"):
		set_group(2)
	elif(image.get_basename().get_file()[0] <= "p"):
		set_group(3)
	else:
		set_group(4)
	self.start_pos = spawn_position

func set_group(group: GameLogic.GROUPS) -> void:
	self._group = group

func get_group() -> GameLogic.GROUPS:
	return self._group

func get_pixels() -> Vector2:
	var sprite = $ItemSprite
	var tex_size = sprite.region_enabled if sprite.region_rect.size else sprite.texture.get_size()
	var global_scale = self.global_transform.get_scale()
	return tex_size * global_scale

func set_image(img: String):
	$ItemSprite.set_texture(load(img))

func get_image():
	return $ItemSprite.get_texture().resource_path

func is_dragged():
	return self.dragging

func disable_area():
	$Hitbox/AreaShape.disabled = true

func reset():
	self.position = start_pos
	
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
