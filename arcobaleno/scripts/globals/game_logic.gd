extends Node

const N_FRUITS: int = 10
const N_COLOR: int = 5

enum GROUPS {WHITE, ORANGE, GREEN, BLUE, RED}

signal correct_fruit
signal uncorrect_fruit

var _score: Array[int]
var _max_score: Array[int]

func _ready() -> void:
	for i in range(N_COLOR):
		_score.append(0)
		_max_score.append(0)

func connect_to_target(receiver):
	self.correct_fruit.connect(receiver._on_correct_fruit)
	self.uncorrect_fruit.connect(receiver._on_uncorrect_fruit)

func item_released(fruit: Item, area: Area2D) -> void:
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

func _on_correct(fruit: Item) -> void:
	var group = fruit.get_group()
	_score[group] += 1
	self.correct_fruit.emit(fruit)
	if _score[group] == _max_score[group]:
		_group_completed(group)

func _on_uncorrect(fruit: Item) -> void:
	self.uncorrect_fruit.emit(fruit)

func _group_completed(group: GROUPS) -> void:
	pass
