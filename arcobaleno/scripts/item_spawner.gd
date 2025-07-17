extends Node2D

@export var scene_to_instantiate : PackedScene

const TOTAL_MAX_ITEMS = 20
const LINE_MAX_ITEMS = 6

var spawn_position : Vector2
var spawned_items : int

var offset : float
var screen_size : float

var images : Array

signal control_waiter

func _ready() -> void:
	self.offset = -1.0
	self.spawn_position = Vector2(0, 0)
	self.spawned_items = 0
	self.images = []
	get_images_from_dir("res://art/graphics/fruit")

func _set_offset(item):
	if self.offset == -1.0:
		self.offset = (self.screen_size / LINE_MAX_ITEMS) - item.get_pixels().x

func animate(item, new_pos = self.spawn_position):
	var tween = create_tween()
	if new_pos == self.spawn_position:
		item.position.x = 1200	
	tween.tween_property(item, "position", new_pos - Vector2(25, 0), 0.8).set_delay(0.12 * self.spawned_items).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(item, "position", new_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
func spawn():
	var item = scene_to_instantiate.instantiate()
	_set_offset(item)
	
	self.spawn_position.x += offset
	if self.spawned_items >= 1:
		self.spawn_position.x += item.get_pixels().x
	
	animate(item)
	
	# list is already shuffled
	var img = self.images.pop_back()
	item.setup(img, self.spawn_position)
	add_child(item)
	
func spawn_all_possible():
	if self.spawned_items >= LINE_MAX_ITEMS or self.spawned_items >= TOTAL_MAX_ITEMS:
		return
	
	spawn()
	
	self.spawned_items += 1
	
	
	spawn_all_possible()

func get_images_from_dir(path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		print("Error in path: ", path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var new_path = path.path_join(file_name)
			if new_path.get_extension().to_lower() == "png":
				self.images.append(new_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	self.images.shuffle()
	return

func shift(last_moved_item : Item):
	var children = get_children()
	var children_size = children.size()
	var moved_item_index = last_moved_item.get_index()
	
	while(children[0] != last_moved_item):
		children.pop_front()
		children_size -= 1
	
	var i = 1
	while(i < children.size()):
		if children[i].is_dropped():
			children.pop_at(i)
			children_size -= 1
		else:
			i += 1
	
	for j in range(children_size - 1, 0, -1):
		animate(children[j], children[j - 1].start_pos)
		children[j].start_pos = children[j - 1].start_pos

func spawn_and_shift(last_moved_item : Item):
	#spawn()
	shift(last_moved_item)
	
func _set_screen_size():
	self.screen_size = $"..".size.x # offset is calculated in spawn()
	self.control_waiter.emit()

func _on_gui_tree_entered() -> void:
	call_deferred("_set_screen_size")
	await self.control_waiter
	spawn_all_possible()
