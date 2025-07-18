extends HBoxContainer

const TOTAL_SLOT = 6

signal enough_slot

func _ready() -> void:
	_create_slot()
	
	_start_fruits(FruitFactory.create_fruits())

func _create_slot() -> void:
	for i in range(FruitFactory.TOTAL_ITEMS):
		var slot = preload("res://scenes/components/slot.tscn").instantiate()
		add_child(slot)
		if i >= TOTAL_SLOT:
			slot.visible = false

func _start_fruits(fruits: Array[Fruit]) -> void:
	for i in range(FruitFactory.TOTAL_ITEMS):
		get_child(i).add_child(fruits[i])

func _swap_visibility(enter: Slot, exit: Slot) -> void:
	_animate_entering(enter)
	enter.visible = true
	exit.visible = false

func shift_right() -> void:
	var child_count = get_child_count()
	if child_count <= TOTAL_SLOT:
		return
	
	var exiter = get_child(TOTAL_SLOT - 1)
	var enterer = get_child(child_count - 1) as Slot
	
	var original_positions = get_children_global_positions()
	var first = get_child(0) as Slot
	original_positions[enterer] = original_positions[first] - Vector2(get_theme_constant("separation") + first.size.x, 0)
	
	move_child(enterer, 0)
	_swap_visibility(enterer, exiter)
	
	_animate_children(original_positions, true)

func shift_left() -> void:
	if get_child_count() <= TOTAL_SLOT:
		return
	
	var exiter = get_child(0)
	var enterer = get_child(TOTAL_SLOT) as Slot
	
	var original_positions = get_children_global_positions()
	var last = get_child(TOTAL_SLOT - 1) as Slot
	original_positions[enterer] = original_positions[last] + Vector2(get_theme_constant("separation") + last.size.x, 0)
	
	move_child(exiter, -1)
	_swap_visibility(enterer, exiter)
	
	_animate_children(original_positions, false)

func moved(moved_fruit: Fruit) -> void:
	var empty_slot: Slot = moved_fruit.get_parent()
	empty_slot.remove_child(moved_fruit)	# we'll queue_free the slot but we don't want to lose the fruit	
	var new_visible: Slot = get_child(TOTAL_SLOT) as Slot
	
	var original_positions = get_children_global_positions(empty_slot)
	
	if new_visible:
		var last = get_child(TOTAL_SLOT - 1) as Slot
		if original_positions.is_empty():
			original_positions[last] = last.global_position
		original_positions[new_visible] = original_positions[last] + Vector2(get_theme_constant("separation") + last.size.x, 0)
		if last == empty_slot:
			original_positions.erase(last)
		_animate_entering(new_visible)
		new_visible.visible = true
	
	if get_child_count() - 1 == TOTAL_SLOT:		# must check before queue_free (or i have to wait a frame and bug animation)
		self.enough_slot.emit()
	
	empty_slot.queue_free()
	
	_animate_children(original_positions, false)

func get_children_global_positions(from: Slot = null) -> Dictionary[Slot, Vector2]:
	var positions: Dictionary[Slot, Vector2]
	var from_index = -1
	if from:
		from_index = from.get_index()
	var children := get_children().filter(func(c): return c.visible and c is Slot and c.get_index() > from_index)
	
	for child in children:
		positions[child] = child.global_position
		
	return positions

func _animate_children(old_position: Dictionary[Slot, Vector2], direction_right: bool):
	var direction = 1 if direction_right else -1
	var tween := create_tween()
	tween.set_parallel()

	await get_tree().process_frame  # let layout update

	# animate every slot from old position to new
	for slot in old_position.keys():
		var new_pos = slot.global_position
		slot.global_position = old_position[slot]  # Bring back temporarly
		tween.tween_property(slot, "global_position", new_pos, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		#tween.tween_property(slot, "global_position", new_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _animate_entering(slot: Slot):
	slot.modulate.a = 0
	slot.visible = true
	
	var tween := create_tween()
	tween.set_parallel()
	
	tween.tween_property(slot, "modulate:a", 1, 0.8).set_ease(Tween.EASE_OUT)
