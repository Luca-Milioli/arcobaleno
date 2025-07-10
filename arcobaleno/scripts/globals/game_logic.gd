extends Node

const N_FRUITS: int = 10
const N_COLOR: int = 5

enum GROUPS {WHITE, ORANGE, GREEN, BLUE, RED}

var _score: Array[int]
var _max_score: Array[int]

func _ready() -> void:
	for i in range(N_COLOR):
		_score[i] = 0
		_max_score[i] = 0

func is_correct(fruit: Item, area: Area2D) -> bool:
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
		_on_correct(group)
		return true
	return false

func _on_correct(group: GROUPS) -> void:
	_score[group] += 1
	if _score[group] == _max_score[group]:
		_group_completed(group)

func _group_completed(group: GROUPS) -> void:
	pass
