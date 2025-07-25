extends Control

func _area_manager(event: InputEvent, area: Area2D):
	if event is InputEventMouseButton:
		if not event.pressed:
			# Mouse released
			for fruit in _get_fruits_inside_area2d(area):
				if not fruit.is_dropped():
					GameLogic.fruit_released(fruit, area)

func _get_fruits_inside_area2d(area: Area2D, from_node: Node = null) -> Array[Fruit]:
	var polygon = area.get_node("CollisionPolygon2D").polygon
	var area_xform := area.get_global_transform()
	var found_fruits: Array[Fruit] = []

	# Se non specificato, cerca in tutto il tree
	if from_node == null:
		from_node = get_tree().get_root()

	for node in from_node.get_children():
		if node is Fruit and node.is_visible_in_tree():
			var rect = node.get_global_rect()
			var corners = [rect.position, rect.position + Vector2(rect.size.x, 0), rect.position + Vector2(0, rect.size.y),rect.position + rect.size]
			for corner in corners:
				var local_corner = area_xform.affine_inverse() * corner
				if Geometry2D.is_point_in_polygon(local_corner, polygon):
					found_fruits.append(node)
					break  # Uno basta
		elif node.get_child_count() > 0:
			found_fruits += _get_fruits_inside_area2d(area, node)	# recursive
	
	return found_fruits


func _on_red_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_area_manager(event, $RedArea)


func _on_blue_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_area_manager(event, $BlueArea)


func _on_green_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_area_manager(event, $GreenArea)


func _on_orange_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_area_manager(event, $OrangeArea)


func _on_white_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_manager(event, $WhiteArea)

func resize_fruits(fruit_size: Vector2) -> void:
	for c in get_children():
		if c is Fruit:
			c.size = fruit_size
