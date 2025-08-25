## Logic of the game such as managing score, win, if a fruit is placed correctly.
## Singleton.
extends Node

class_name GameLogicScript

## Every value is a color of the rainbow.
enum GROUPS { WHITE, ORANGE, GREEN, BLUE, RED }

## Emit when a Fruit is placed correctly.
signal correct_fruit
## Emit when a Fruit is placed wrongly.
signal uncorrect_fruit
## Emit when every Fruit of the same group is placed correctly.
signal group_completed
## Emit when every group is completed.
signal win

## Score of each group.
var _score: Array[int]
## Number of group completed.
var _n_group_completed: int = 0
## Max score for groups.
var _max_score: int


## Calls _start() and fill _score of zeros.
func _ready() -> void:
	_start()
	for i in range(GROUPS.size()):
		_score.append(0)


## Resets attributes and calls _start().
func reset_and_restart() -> void:
	_reset()
	_start()


## Inizialize attributes.
func _start() -> void:
	self._max_score = DataManager.get_fruits_per_group()


## Connect signals to the Gui.
func connect_to_target(receiver) -> void:
	self.correct_fruit.connect(receiver._on_correct_fruit)
	self.uncorrect_fruit.connect(receiver._on_uncorrect_fruit)
	self.group_completed.connect(receiver._on_group_completed)


## Resets attributes.
func _reset() -> void:
	self._max_score = 0
	for i in range(GROUPS.size()):
		self._score[i] = 0
	self._n_group_completed = 0


## Called when a Fruit is released inside an Area2D. Determines if it corrects or wrong.
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


## Called when a Fruit is correctly placed. Starts audio, emit signal, update score.
func _on_correct(fruit: Fruit) -> void:
	AudioManager.correct()
	var group = fruit.get_group()
	_score[group] += 1
	self.correct_fruit.emit(fruit)
	if _score[group] >= self._max_score:
		_group_completed(group)


## Called when a Fruit is uncorrectly placed. Emit signal.
func _on_uncorrect(fruit: Fruit) -> void:
	#AudioManager.wrong()	is called on Fruit.reset bc out of rainbow this method isn't called
	self.uncorrect_fruit.emit(fruit)


## Called when a group is completed. Emit signal. Check if match is won.
func _group_completed(group: GROUPS) -> void:
	self._n_group_completed += 1
	self.group_completed.emit(group)
	if self._n_group_completed >= FruitFactory.get("n_lines"):
		_win()


## Called when match is won. Emit signal.
func _win():
	self.win.emit()
