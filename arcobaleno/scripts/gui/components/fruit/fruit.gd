extends TextureRect

class_name Fruit

signal is_dragging

var dragging : bool = false
var drag_offset : Vector2
var _dropped : bool = false
var _fruit: String
var _group: GameLogic.GROUPS

func set_dropped(dropped: bool) -> void:
	self._dropped = dropped
	_disable_drag()

func is_dropped() -> bool:
	return self._dropped
	
func setup(name: String, group: GameLogic.GROUPS) -> void:
	set_image("art/graphics/fruit/" + name.to_lower() + ".png")	# image name must be consistent with csv
	set_name(name)
	set_group(group)

func set_group(group: GameLogic.GROUPS) -> void:
	self._group = group

func get_group() -> GameLogic.GROUPS:
	return self._group

func set_image(img: String) -> void:
	set_texture(load(img))

func get_image() -> String:
	return get_texture().resource_path

func set_dragging(dragging: bool) -> void:
	self.dragging = dragging
	

func is_dragged() -> bool:
	return self.dragging

func _disable_drag() -> void:
	if (self._dropped):
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func reset():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0
	scale = Vector2(0.6, 0.6)
	position = (get_parent_area_size() - get_parent_area_size() * scale) / 2

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			set_dragging(true)
			drag_offset = get_global_mouse_position() - global_position

func _process(delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position() - drag_offset
		var screen_size = get_viewport_rect().size
		
		# Clamp la posizione per restare dentro lo schermo
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - self.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - self.size.y)

		global_position = mouse_pos

func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Ferma il dragging
		if dragging:
			set_dragging(false)
			await get_tree().process_frame
			if not _dropped:
				reset()
