extends HBoxContainer

const TOTAL_SLOT: int = 6

signal enough_slot
signal fruit_ready
signal tween_finished


func _ready() -> void:
	_create_slot()

	_start_fruits(FruitFactory.create_fruits())


func _create_slot() -> void:
	for i in range(FruitFactory.get_total_fruits()):
		var slot = preload("res://scenes/components/slot.tscn").instantiate()
		if i >= TOTAL_SLOT:
			slot.visible = false
		add_child(slot)


func _start_fruits(fruits: Array[Fruit]) -> void:
	for i in range(FruitFactory.get_total_fruits()):
		var slot = get_child(i)
		if slot is Slot:
			slot.add_child(fruits.pop_front())
	self.fruit_ready.emit()


func _swap_visibility(enter: Slot, exit: Slot) -> void:
	enter.visible = true
	_animate_enter_or_exit(enter, true)
	await _animate_enter_or_exit(exit, false)
	exit.visible = false


func shift_right() -> void:
	var child_count = get_child_count()
	if child_count <= TOTAL_SLOT:
		return

	var exiter = get_child(TOTAL_SLOT - 1) as Slot
	var enterer = get_child(child_count - 1) as Slot

	var original_positions = get_children_global_positions()
	var first = get_child(0) as Slot
	original_positions[enterer] = (
		original_positions[first] - Vector2(get_theme_constant("separation") + first.size.x, 0)
	)

	move_child(enterer, 0)
	_swap_visibility(enterer, exiter)

	_animate_children(original_positions, true)


func shift_left() -> void:
	if get_child_count() <= TOTAL_SLOT:
		return

	var exiter = get_child(0) as Slot
	var enterer = get_child(TOTAL_SLOT) as Slot

	var original_positions = get_children_global_positions()
	var last = get_child(TOTAL_SLOT - 1) as Slot
	original_positions[enterer] = (
		original_positions[last] + Vector2(get_theme_constant("separation") + last.size.x, 0)
	)

	move_child(exiter, -1)
	_swap_visibility(enterer, exiter)

	_animate_children(original_positions, false, exiter)


func moved(moved_fruit: Fruit) -> void:
	var n_child = get_child_count()
	if n_child - 1 == TOTAL_SLOT:
		self.enough_slot.emit()

	var empty_slot: Slot = moved_fruit.get("_slot_parent")
	var new_visible: Slot = get_child(TOTAL_SLOT) if n_child > TOTAL_SLOT else null

	var original_positions = get_children_global_positions(empty_slot)

	if new_visible:
		var last = get_child(TOTAL_SLOT - 1) as Slot
		original_positions[new_visible] = (
			last.global_position + Vector2(get_theme_constant("separation") + last.size.x, 0)
		)

	var slot_position = empty_slot.global_position
	var slot_size = empty_slot.size
	remove_child(empty_slot)
	empty_slot.removing.emit(empty_slot, slot_position, slot_size)

	if original_positions.is_empty():
		_tween_finished_after_timer(0.8)  # wait duration of a normal tween because otherwise gui is not ready to catch signal
	else:
		_animate_on_move(original_positions)

	if new_visible:
		new_visible.visible = true
		_animate_enter_or_exit(new_visible, true)

	await _animate_enter_or_exit(empty_slot, false, 0.4)

	empty_slot.queue_free()


func _tween_finished_after_timer(duration: float) -> void:
	await get_tree().create_timer(duration).timeout
	self.tween_finished.emit()


func get_children_global_positions(from: Slot = null) -> Dictionary[Slot, Vector2]:
	var positions: Dictionary[Slot, Vector2]
	var from_index = -1
	if from:
		from_index = from.get_index()
	var children := get_children().filter(
		func(c): return c.visible and c is Slot and c.get_index() > from_index
	)

	for child in children:
		positions[child] = child.global_position

	return positions


func _animate_children(
	old_position: Dictionary[Slot, Vector2], direction_right: bool, exiter: Slot = null
) -> void:
	var tween := create_tween()
	tween.set_parallel()
	var slots = old_position.keys()

	disable_fruits(slots, true)  # disable dragging fruit during animation
	tween.finished.connect(disable_fruits.bind(slots, false))  # re-enable when finished

	await get_tree().process_frame  # let layout update

	if exiter:
		exiter.global_position = (
			old_position[exiter]
			- 1.5 * Vector2(exiter.size.x + get_theme_constant("separation"), 0)
		)
	# animate every slot from old position to new
	for slot in old_position.keys():
		var new_pos = (
			slot.global_position
			+ Vector2(slot.size.x / 2.0 + get_theme_constant("separation") / 2.0, 0)
		)
		slot.global_position = old_position[slot]  # Bring back temporarly
		(
			tween
			. tween_property(slot, "global_position", new_pos, 0.8)
			. set_trans(Tween.TRANS_QUAD)
			. set_ease(Tween.EASE_IN_OUT)
		)


func _animate_on_move(old_position: Dictionary[Slot, Vector2]) -> void:
	var tween := create_tween()
	tween.set_parallel()
	var slots = old_position.keys()

	disable_fruits(slots, true)  # disable dragging fruit during animation
	tween.finished.connect(disable_fruits.bind(slots, false))  # re-enable when finished
	tween.finished.connect(func(): self.tween_finished.emit())

	await get_tree().process_frame  # let layout update

	# animate every slot from old position to new
	for slot in slots:
		var new_pos = slot.global_position
		slot.global_position = old_position[slot]  # Bring back temporarly

		(
			tween
			. tween_property(slot, "global_position", new_pos, 0.8)
			. set_trans(Tween.TRANS_QUAD)
			. set_ease(Tween.EASE_IN_OUT)
		)


func _animate_enter_or_exit(slot: Slot, enter: bool, duration: float = 0.8) -> void:  # enter = true, exit = false
	var tween := create_tween()

	var end_modulate
	if enter:
		slot.modulate.a = 0
		end_modulate = 1
	else:
		end_modulate = 0

	tween.set_parallel()
	(
		tween
		. tween_property(slot, "modulate:a", end_modulate, duration)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_IN if enter else Tween.EASE_OUT)
	)
	await tween.finished


func disable_fruits(slots: Array, disable: bool) -> void:
	for slot in slots:
		for fruit in slot.get_children():
			if fruit is Fruit:
				fruit.disable_drag(disable)
				break
