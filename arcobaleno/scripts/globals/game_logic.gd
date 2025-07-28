extends Node

enum GROUPS { WHITE, ORANGE, GREEN, BLUE, RED }

signal correct_fruit
signal uncorrect_fruit
signal group_completed
signal win

var _score: Array[int]
var _n_group_completed: int = 0
var _max_score: int


func _ready() -> void:
	_start()
	for i in range(GROUPS.size()):
		_score.append(0)


func reset_and_restart() -> void:
	_reset()
	_start()


func _start() -> void:
	self._max_score = DataManager.get_fruits_per_group()


func connect_to_target(receiver) -> void:
	self.correct_fruit.connect(receiver._on_correct_fruit)
	self.uncorrect_fruit.connect(receiver._on_uncorrect_fruit)
	self.group_completed.connect(receiver._on_group_completed)


func _reset() -> void:
	self._max_score = 0
	for i in range(GROUPS.size()):
		self._score[i] = 0
	self._n_group_completed = 0


func fruit_released(fruit: Fruit, area: Area2D) -> void:
	var group = fruit.get_group()
	var correct = false
	match group:
		GROUPS.WHITE:
			if area.get_name() == "WhiteArea":
				correct = true
		GROUPS.ORANGE:
			if area.get_name() == "OrangeArea":
				correct = true
		GROUPS.GREEN:
			if area.get_name() == "GreenArea":
				correct = true
		GROUPS.BLUE:
			if area.get_name() == "BlueArea":
				correct = true
		GROUPS.RED:
			if area.get_name() == "RedArea":
				correct = true
	if correct:
		_on_correct(fruit)
	else:
		_on_uncorrect(fruit)


func _on_correct(fruit: Fruit) -> void:
	AudioManager.correct()
	var group = fruit.get_group()
	_score[group] += 1
	self.correct_fruit.emit(fruit)
	if _score[group] >= self._max_score:
		_group_completed(group)


func _on_uncorrect(fruit: Fruit) -> void:
	#AudioManager.wrong()	is called on Fruit.reset bc out of rainbow this method isn't called
	self.uncorrect_fruit.emit(fruit)


func _group_completed(group: GROUPS) -> void:
	self._n_group_completed += 1
	self.group_completed.emit(group)
	if self._n_group_completed >= FruitFactory.get("n_lines"):
		_win()


func _win():
	self.win.emit()
