extends Control

@onready var label_node = $Button

func _ready() -> void:
	# all this does is dynamically name the button
	await get_tree()
	var parent_name = self.name
	label_node.text = parent_name
