extends HBoxContainer

const DATA_PATH = "res://data/content.csv"
const TOTAL_ITEMS = 10
const TOTAL_SLOT = 6

var _position_group: Array[GameLogic.GROUPS]

func _ready() -> void:
	_create_slot()
	
	var fruits = _pick_fruits()
	
	_create_fruits(fruits)

func _create_slot() -> void:
	for i in range(TOTAL_SLOT):
		add_child(preload("res://scenes/slot.tscn").instantiate())

func _read_csv(path: String, separator: String) -> Array:
	var data := []
	var file := FileAccess.open(path, FileAccess.READ)
	
	if not file:
		push_error("Errore nell'aprire il file.")
		return []

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue
		var values = line.split(separator, false) # false = non rimuove i campi vuoti
		data.append(values)

	file.close()
	return data

func _pick_fruits() -> Dictionary[String, GameLogic.GROUPS]:
	var data = _read_csv(DATA_PATH, "|")
	
	var n_lines = data.size()
	if n_lines != GameLogic.GROUPS.size():
		push_error("Incompatible lines with number of groups")
	
	var n_columns = data[0].size()
	for group in data:
		if group.size() != n_columns:
			push_error("Incompatible columns")
	
	var cols = _pick_columns(n_columns)
	var fruits = _get_fruits_from_cols(data, cols, n_lines)
	return fruits

func _pick_columns(n_col: int) -> Array[int]:
	if n_col < 4:
		push_error("Not enough columns")
		return []
	
	n_col -= 2	# don't calculate first and last column
	
	var col1 = randi() % n_col + 1 # add 1 for skipping the first column
	var col2 = col1
	
	while(col1 == col2):
		col2 = randi() % n_col + 1
	
	return [col1, col2]

func _get_fruits_from_cols(data: Array, cols: Array[int], n_lines: int = -1) -> Dictionary[String, GameLogic.GROUPS]:
	if n_lines == -1:
		n_lines = data.size()
	
	var fruits: Dictionary[String, GameLogic.GROUPS]
	for i in range(n_lines):
		for j in cols:
			fruits[data[i][j]] = i as GameLogic.GROUPS
	
	return fruits

func _create_fruits(fruits: Dictionary[String, GameLogic.GROUPS]) -> void:
	var shuffled_keys = fruits.keys()
	shuffled_keys.shuffle()
	var i = 0
	for fruit in shuffled_keys:
		if i < TOTAL_SLOT:
			get_child(i).get_node("Fruit").setup(fruit.to_lower(), fruits[fruit])
			i += 1
		else:
			var out_child = preload("res://scenes/fruit.tscn").instantiate()
			out_child.setup(fruit.to_lower(), fruits[fruit])
			add_child(out_child)

func _shift(empty_slot) -> void:
	var children = get_children()
	var children_size = children.size()
	var moved_item_index = empty_slot.get_index()
	var out_fruit = null
	
	while(children[0] != empty_slot):
		children.pop_front()
		children_size -= 1
	
	while(children[children_size - 1] is Fruit):
		if(children[children_size - 1].is_dropped()):
			children.pop_back()
		else:
			out_fruit = children.pop_back()
		children_size -= 1
	
	for j in range(children_size - 1):
		var next = children[j + 1].get_child(0)
		var target_global_pos = children[j].global_position + next.position
		children[j + 1].remove_child(next)
		children[j].add_child(next)
		#_animate(next, target_global_pos)
	
	if out_fruit:
		remove_child(out_fruit)
		children[children_size - 1].add_child(out_fruit)
		
		out_fruit.scale = Vector2(0.6, 0.6)
		out_fruit.reset()
	else:
		remove_child(children[children_size - 1])

func shift(moved_fruit: Fruit) -> void:
	var empty_slot = moved_fruit.get_parent()
	empty_slot.remove_child(moved_fruit)
	_shift(empty_slot)

func _animate(fruit: Fruit, new_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(fruit, "global_position", new_pos, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(fruit, "global_position", new_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
