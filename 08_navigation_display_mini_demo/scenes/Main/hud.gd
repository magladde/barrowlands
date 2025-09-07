extends CanvasLayer

@onready var container: Node2D = $POIArrowContainer
@onready var arrow: Sprite2D = $POIArrowContainer/POIArrow
@onready var distance_label: Label = $POIArrowContainer/DisanceLabel

var current_poi: Node2D = null
var player: Node2D = null

func _ready() -> void:
	# Ensure the arrow has a texture and rotates around its center
	if arrow.texture == null:
		arrow.texture = load("res://assets/yellow_arrow.png") # replace with your path
	arrow.centered = true
	arrow.rotation = 0.0
	container.visible = false  # hide until we have valid targets
	distance_label.position = Vector2(0, 40)


func set_player(p: Node2D) -> void:
	player = p

func set_current_poi(poi: Node2D) -> void:
	current_poi = poi

func format_distance(meters: float) -> String:
	if meters < 10_000:
		return str(round(meters)) + " km"
	elif meters < 1_000_000:
		return str(round(meters / 1000.0)) + " Mm"
	elif meters < 30_000_000:
		return str(round(meters / 1_000_000.0)) + " ls"
	else:
		var light_seconds = meters / 299_792_458.0
		return str(snapped(light_seconds, 2)) + " ls"

func _process(delta: float) -> void:
	if current_poi == null or player == null:
		container.visible = false
		return

	container.visible = true

	# 1) Keep the container fixed at the right-center of the screen
	var rect := get_viewport().get_visible_rect()
	container.position = Vector2(rect.size.x - 150.0, rect.size.y * 0.5)  # 50 px inset from right edge

	# 2) Rotate the arrow to face from player toward POI
	var dir := (current_poi.global_position - player.global_position)
	arrow.rotation = dir.angle() + deg_to_rad(90)
	
	# 3) Update distance label
	var distance := dir.length()
	distance_label.text = format_distance(distance)
