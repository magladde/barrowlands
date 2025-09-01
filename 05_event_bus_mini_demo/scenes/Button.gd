extends Button


func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	var parent_name = get_parent().name
	EventBus.emit_signal("system_selected", parent_name)
