extends Node2D

@export_file("*.json") var data_path: String = "res://data/system_data.json"
@export var system_id: String = "sol"
@onready var background_rect: TextureRect = $Background

var pois: Array = []
var current_poi_index := 0

func _ready() -> void:
	load_system(system_id)
	
func _read_text(data_path: String) -> String:
	if not FileAccess.file_exists(data_path):
		return ""
	var f := FileAccess.open(data_path, FileAccess.READ)
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
	print("loading the %s system" % system_id)
	# step 1 - read in json object
	var text := _read_text(data_path)
	
	# return error if failed to read
	if text.is_empty():
		push_error("Could not read json at %s" % data_path)
		return
	
	# convert string into a dictionary using the JSON method
	var json_obj = JSON.new()
	var error = json_obj.parse(text)
	
	# return error 
	if error != OK:
		push_error("JSON Parse error at")
		return
	
	var sys_dict = json_obj.data
	var system_data = sys_dict.get(id, null)
	
	# check json for system
	if system_data == null:
		push_error("System id not found: %s" % id)
	
	# 2 - set background
	if system_data.has("background"):
		var bg := _load_texture(system_data.background)
		if bg:
			background_rect.texture = bg
			background_rect.custom_minimum_size= Vector2(20_000, 20_000)
			background_rect.stretch_mode = TextureRect.STRETCH_TILE

	# 3 - set poi sprites
	if system_data.has("pois"):
		var poi_data = system_data.get("pois", null)
		if poi_data == null:
			push_error("missing poi data")
		for point in poi_data:
			# parse info for pois from json object
			var position = point.get("position", null)
			var poi_id = point.get("id", null)
			var sprite_path = point.get("sprite", null)
			var global_scale = point.get("global_scale", null)
			var type = point.get("type", null)
			var faction = point.get("faction", null)
			
			# dynamically create a sprite2d node, and populate in the scene
			var sprite = Sprite2D.new()
			sprite.texture = load(sprite_path)
			sprite.position = Vector2(position[0], position[1])
			sprite.scale = Vector2(global_scale, global_scale)
			sprite.name = poi_id
			sprite.z_index = 0
			add_child(sprite)
			
			# add pois to an array that we can cycle through for ui/nav
			pois.append(sprite)

func add_reticule_to_poi(poi_node: Sprite2D, scale_factor := 1.5) -> void:
	var reticule = Sprite2D.new()
	reticule.texture = load("res://assets/yellow_reticule.png")
	
	var texture_size = poi_node.texture.get_size()
	var visual_radius = texture_size.length() * poi_node.scale.x  # Approximate size
	print("visual_radius")
	print(visual_radius)
	var reticule_scale = visual_radius / reticule.texture.get_size().x
	reticule.scale = Vector2(reticule_scale, reticule_scale) * 1.2  # Add paddingr
	
	# rename node
	reticule.name = "PoiReticule"
	
	# modify the z index so you can see it
	reticule.z_index = poi_node.z_index + 1
	
	# add as child so it follows
	poi_node.add_child(reticule)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cycle_poi"):
		# might want to do this differently
		if pois.size() <= 0:
			pass
		current_poi_index = (current_poi_index + 1) % pois.size()
		
		# update hud with currently selected poi
		var current_poi = pois[current_poi_index]
		$HUD/POILabel.text = current_poi.name
		# set poi in hud script
		$HUD.set_current_poi(pois[current_poi_index])
		# set ship in hud script
		$HUD.player = $Ship


		
		# remove reticule if you cycle
		for poi in pois:
			if poi.has_node("PoiReticule"):
				poi.get_node("PoiReticule").queue_free()
		
		# add highlight to selected poi
		add_reticule_to_poi(current_poi)
