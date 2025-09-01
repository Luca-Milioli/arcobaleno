# Script for general useful methods. It contains static methods only.
extends Object
class_name Utils


## Method called for enabling or disabling every button contained in a node
## recursively.
static func recursive_disable_buttons(obj: Node, disabled: bool):
	var children = obj.get_children()
	if obj is BaseButton:
		obj.disabled = disabled
	if not children.is_empty():
		for child in children:
			recursive_disable_buttons(child, disabled)
