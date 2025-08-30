extends Node2D

@export_file("*.json") var data_path: String = "res://data/systems.json"
@export var system_id: String = "vega"

@onready var background_rect: TextureRect = $Background
@onready var planet_root: Node2D = $PlanetRoot

func _ready() -> void:
	load_system(system_id)

func _read_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var t := f.get_as_text()
	f.close()
	return t

func _load_texture(path: String) -> Texture2D:
	var res := ResourceLoader.load(path)
	if res is Texture2D:
		return res
	else:
		return null

func load_system(id: String) -> void:
	# Step 1 - read in json object, comes in as a json string
	var text := _read_text(data_path)
	if text.is_empty():
		push_error("Could not read JSON at %s" % data_path)
		return

	# convert string to a dictionary using json
	var json_obj = JSON.new()
	var error = json_obj.parse(text)
	if error != OK:
		push_error("JSON Parse error")
		return
	
	# parse out the given system
	var sys_dict = json_obj.data
	var sys_data = sys_dict.get(id, null)
	if sys_data == null:
		push_error("System id not found: %s" % id)
	
	# 2 - Set background
	if sys_data.has("background"):
		var bg := _load_texture(sys_data.background)
		if bg:
			background_rect.texture=bg
	
	# 3 - Set planet sprite
	if sys_data.has("planet"):
		var p: Dictionary = sys_data["planet"]
		var sprite := Sprite2D.new()
		planet_root.add_child(sprite)
		
		if p.has("sprite"):
			var tex := _load_texture(p.sprite)
			if tex:
				sprite.texture = tex
		
		if p.has("position"):
			sprite.position = Vector2(p.position[0], p.position[1])
			sprite.global_scale = Vector2(p.global_scale, p.global_scale)
