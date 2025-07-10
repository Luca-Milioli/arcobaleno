extends Node2D

@export var scene_to_instantiate : PackedScene

const TOTAL_MAX_ITEMS = 30
const LINE_MAX_ITEMS = 7

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

func spawn():
	var item = scene_to_instantiate.instantiate()
	_set_offset(item)
	
	self.spawn_position.x += offset
	if self.spawned_items >= 1:
		self.spawn_position.x += item.get_pixels().x
	
	var tween = create_tween()
	item.position.x = 1200
	tween.tween_property(item, "position", spawn_position - Vector2(25, 0), 0.8).set_delay(0.12 * self.spawned_items).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(item, "position", spawn_position, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	#item.position = spawn_position
	
	# 86
	
	# list is already shuffled
	var img = self.images.pop_back()
	item.set_image(img)
	item.set_name(img.get_basename().get_file())
	#print("ITEM: "+str(item.position) + " | "+str(item.get_image()))
	add_child(item)
	
func spawn_all_possible():
	if self.spawned_items >= LINE_MAX_ITEMS:
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

	
func _set_screen_size():
	self.screen_size = $"..".size.x # offset is calculated in spawn()
	self.control_waiter.emit()

func _on_gui_tree_entered() -> void:
	call_deferred("_set_screen_size")
	await self.control_waiter
	spawn_all_possible()
