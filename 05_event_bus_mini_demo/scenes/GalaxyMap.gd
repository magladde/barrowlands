extends Control

var current_system = ""
const ACTIVE_TEXTURE = preload("res://assets/circle_small_active.png")
const DEACTIVE_TEXTURE = preload("res://assets/circle_small_deactive.png")

func _ready():
	EventBus.connect("system_selected", Callable(self, "_on_system_selected"))
	

func udpate_system_image(current_system: String):
	for system in $SystemContainer.get_children():
		var icon: TextureButton = system.get_node("Icon")
		if system.name != current_system:
			icon.texture_normal = DEACTIVE_TEXTURE
			continue
		icon.texture_normal = ACTIVE_TEXTURE

func _on_system_selected(system_name: String):
	current_system = system_name
	udpate_system_image(current_system)
