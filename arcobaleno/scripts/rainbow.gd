extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _area_manager(event: InputEvent, area: Area2D):
	if event is InputEventMouseButton and event.pressed == false:
		# Mouse released
		for overlapping in area.get_overlapping_areas():
			var item = overlapping.get_parent()
			if item is Item and not item.is_dragged():
				if GameLogic.is_correct(item, area):
					print(" --> "+str(item.get_name())+" | "+str(area.get_name()))
					item.get_node("Hitbox/AreaShape").disabled = true


func _on_red_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $RedArea)
	
			
func _on_blue_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $BlueArea)


func _on_green_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $GreenArea)


func _on_orange_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $OrangeArea)


func _on_white_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $WhiteArea)
