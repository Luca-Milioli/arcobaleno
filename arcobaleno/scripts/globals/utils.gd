extends Object

class_name Utils

static func recursive_disable_buttons(obj : Node, disabled):
	var children = obj.get_children()
	if obj is BaseButton:
		obj.disabled = disabled
	if not children.is_empty():
		for child in children:
			recursive_disable_buttons(child, disabled)
