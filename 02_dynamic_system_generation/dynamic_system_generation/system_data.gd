extends Node

var systems = {}

func _ready() -> void:
	var file = FileAccess.open("res://data/systems.json", FileAccess.READ)
	if file:
		systems = JSON.parse_string(file.get_as_text())
		if systems == null:
			print("parsing systems.json failed")
		file.close()
