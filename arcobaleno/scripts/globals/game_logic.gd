extends Node

const N_FRUITS: int = 10
const N_GROUP: int = 5

enum GROUPS {WHITE, ORANGE, GREEN, BLUE, RED}

signal correct_fruit
signal uncorrect_fruit
signal group_completed
signal win

var _score: Array[int]
var _max_score: Array[int]
var _n_group_completed: int = 0

func _ready() -> void:
	var max_score = N_FRUITS / N_GROUP
	for i in range(N_GROUP):
		_score.append(0)
		_max_score.append(max_score)

func connect_to_target(receiver) -> void:
	self.correct_fruit.connect(receiver._on_correct_fruit)
	self.uncorrect_fruit.connect(receiver._on_uncorrect_fruit)
	self.group_completed.connect(receiver._on_group_completed)

func reset() -> void:
	for i in range(N_GROUP):
		_score[i] = 0
	_n_group_completed = 0

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
	if _score[group] >= _max_score[group]:
		_group_completed(group)

func _on_uncorrect(fruit: Fruit) -> void:
	AudioManager.wrong()
	self.uncorrect_fruit.emit(fruit)

func _group_completed(group: GROUPS) -> void:
	self._n_group_completed += 1
	self.group_completed.emit(group)
	if _n_group_completed >= N_GROUP:
		_win()

func _win():
	self.win.emit()
