extends Button
signal route_selected(route: String)

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	
func _on_pressed() -> void:
	print("button pressed")
	emit_signal("route_selected", "vega <-> alpha centarui")
