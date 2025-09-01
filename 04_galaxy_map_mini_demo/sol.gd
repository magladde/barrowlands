extends Button
signal system_selected(system_name: String)

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	
func _on_pressed():
	emit_signal("system_selected", self.name)
