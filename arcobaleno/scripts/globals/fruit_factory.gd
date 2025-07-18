extends DataManager

const TOTAL_ITEMS = 10
const TOTAL_SLOT = 6

var _data = []
var n_lines
var n_columns

func get_data() -> Array:
	if self._data.is_empty():
		self._data = super._read_csv("|")
		self.n_lines = self._data.size()
		self.n_columns = self._data[0].size()
	return self._data

func _pick_fruits() -> Dictionary[String, GameLogic.GROUPS]:
	var data = get_data()
	
	if self.n_lines != GameLogic.GROUPS.size():
		push_error("Incompatible lines with number of groups")
	
	for group in data:
		if group.size() != self.n_columns:
			push_error("Incompatible columns")
	
	var cols = _pick_columns(self.n_columns)
	var fruits = _get_fruits_from_cols(data, cols)
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

func _get_fruits_from_cols(data: Array, cols: Array[int]) -> Dictionary[String, GameLogic.GROUPS]:
	var fruits: Dictionary[String, GameLogic.GROUPS]
	for i in range(self.n_lines):
		for j in cols:
			fruits[data[i][j]] = i as GameLogic.GROUPS
	
	return fruits

func create_fruits() -> Array[Fruit]:
	var fruits = _pick_fruits()
	
	var shuffled_keys = fruits.keys()
	shuffled_keys.shuffle()
	var fruit_scenes: Array[Fruit]
	for fruit in shuffled_keys:
		var new_fruit = preload("res://scenes/components/fruit.tscn").instantiate()
		new_fruit.setup(fruit.to_lower(), fruits[fruit])
		fruit_scenes.append(new_fruit)
	
	return fruit_scenes

func get_feedback(group: GameLogic.GROUPS) -> String:
	var data = get_data()
	return data[group][n_columns - 1]
