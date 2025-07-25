extends TextureRect

class_name Fruit

signal start_drag
signal end_drag

var dragging : bool = false
var drag_offset : Vector2
var _dropped : bool = false
var _group: GameLogic.GROUPS
var _slot_parent: Slot

func set_dropped(dropped: bool) -> void:
	self._dropped = dropped
	if dropped:
		disable_drag(true)

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
	if not self.dragging and dragging and get_parent() is Slot:
		var global_pos = global_position
		var real_size = size
		self._slot_parent = get_parent()
		self._slot_parent.remove_child(self)
		start_drag.emit(self, global_pos, real_size)
	self.dragging = dragging

func is_dragged() -> bool:
	return self.dragging

func disable_drag(disable: bool) -> void:
	disable = disable or self._dropped
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE if disable else Control.MOUSE_FILTER_PASS

func reset():
	var relative_pos = (_slot_parent.get("size") * (Vector2(1, 1) - scale)) / 2
	await _reset_animation(_slot_parent.global_position + relative_pos)
	
	if get_parent() is not Slot:
		end_drag.emit()
		self._slot_parent.add_child(self)
	
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0
	position = relative_pos

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		set_dragging(true)
		drag_offset = get_global_mouse_position() - global_position

func _process(_delta):
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

func _reset_animation(final_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", final_position, 0.3).set_trans(Tween.TRANS_QUAD)
	await tween.finished
