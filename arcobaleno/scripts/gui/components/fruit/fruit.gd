## Manage a Fruit: drag and drop, group.
extends TextureRect
class_name Fruit

## Emit when Fruit starts dragging.
signal start_drag
## Emit when Fruit is released.
signal end_drag

## True if it's dragging.
var dragging: bool = false
## Drag offset since last frame.
var drag_offset: Vector2
## True if it's dropped.
var _dropped: bool = false
## Group which contains it.
var _group: GameLogic.GROUPS
## Slot which contains it.
var _slot_parent: Slot


## Setter for dropped. When true, it disable dragging.
func set_dropped(dropped: bool) -> void:
	self._dropped = dropped
	if dropped:
		disable_drag(true)


## Getter for dropped.
func is_dropped() -> bool:
	return self._dropped


## Inizialize name, texture and group
func setup(name: String, group: GameLogic.GROUPS) -> void:
	set_image("art/graphics/fruit/" + name.to_lower() + ".png")  # image name must be consistent with csv
	set_name(name)
	set_group(group)


## Setter for group.
func set_group(group: GameLogic.GROUPS) -> void:
	self._group = group


## Getter for group.
func get_group() -> GameLogic.GROUPS:
	return self._group


## Set texture from path.
func set_image(path: String) -> void:
	set_texture(load(path))


## Getter for path of texture.
func get_image() -> String:
	return get_texture().resource_path


## Start dragging. It detaches imself from its Slot.
func set_dragging(dragging: bool) -> void:
	if not self.dragging and dragging and get_parent() is Slot:
		var global_pos = global_position
		var real_size = size
		self._slot_parent = get_parent()
		self._slot_parent.remove_child(self)
		start_drag.emit(self, global_pos, real_size)
	self.dragging = dragging


## Getter for dragging.
func is_dragged() -> bool:
	return self.dragging


## Disables drag if disable is true, enables if false. If Fruit is dropped drag can't be enabled.
func disable_drag(disable: bool) -> void:
	disable = disable or self._dropped
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE if disable else Control.MOUSE_FILTER_PASS


## Make Fruit come back to its Slot.
func reset():
	AudioManager.wrong()

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


## Starts and make drag.
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		set_dragging(true)
		drag_offset = get_global_mouse_position() - global_position


## Every frame it drags.
func _process(_delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position() - drag_offset
		var screen_size = get_viewport_rect().size

		# Clamp la posizione per restare dentro lo schermo
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - self.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - self.size.y)

		global_position = mouse_pos


## End drag.
func _unhandled_input(event):
	if (
		event is InputEventMouseButton
		and not event.pressed
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		if dragging:
			set_dragging(false)
			await get_tree().process_frame
			if not _dropped:
				reset()


## Animate the come back to its Slot.
func _reset_animation(final_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", final_position, 0.3).set_trans(Tween.TRANS_QUAD)
	await tween.finished
