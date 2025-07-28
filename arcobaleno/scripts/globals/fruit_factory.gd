extends DataManager

var n_lines: int
var n_columns: int


func _ready() -> void:
	_start()


func reset_and_restart() -> void:
	_start()


func _start():
	super._read_csv()
	self.n_lines = self.fruit_data.size()
	if self.n_lines > GameLogic.GROUPS.size():
		push_error("Incompatible lines with number of groups")

	var cols = self.fruit_data[0].size()
	if cols - 2 < GameLogic.get("_max_score"):
		push_error("Insufficent number of columns")
	else:
		self.n_columns = cols
	for i in range(self.n_lines - 1):
		if self.fruit_data[i + 1].size() != self.n_columns:
			push_error("Incompatible number of columns in row " + str(i + 1))


func get_data() -> Array:
	return super._read_csv()


func get_total_fruits() -> int:
	return self.n_lines * GameLogic.get("_max_score")


func _pick_fruits() -> Dictionary[String, GameLogic.GROUPS]:
	var cols = _pick_columns(self.n_columns - 2)  # don't calculate first and last column
	return _get_fruits_from_cols(self.fruit_data, cols)


func _pick_columns(n_col: int) -> Array[int]:
	var cols_picked: Array[int]
	var cols_pickable = range(n_col)

	for i in range(GameLogic.get("_max_score")):
		cols_picked.append(cols_pickable.pop_at(randi() % n_col) + 1)  # add 1 to skip first column
		n_col -= 1
	return cols_picked


func _get_fruits_from_cols(data: Array, cols: Array[int]) -> Dictionary[String, GameLogic.GROUPS]:
	var fruits: Dictionary[String, GameLogic.GROUPS]
	for i in range(self.n_lines):
		for j in cols:
			fruits[data[i][j]] = i as GameLogic.GROUPS

	return fruits


func create_fruits() -> Array[Fruit]:
	var fruit_scenes: Array[Fruit]

	var fruits = _pick_fruits()

	var shuffled_keys = fruits.keys()
	shuffled_keys.shuffle()

	for fruit in shuffled_keys:
		var new_fruit = preload("res://scenes/components/fruit.tscn").instantiate()
		new_fruit.setup(fruit, fruits[fruit])
		fruit_scenes.append(new_fruit)

	return fruit_scenes


func get_feedback(group: GameLogic.GROUPS) -> String:
	return get_data()[group][n_columns - 1]
