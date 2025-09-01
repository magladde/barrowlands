extends Control

var current_system = "Sol"
var current_route = "sol <-> vega"

const DEFAULT_TEXTURE = preload("res://assets/circle_small.png")
const ACTIVE_TEXTURE = preload("res://assets/circle_small_clicked.png")

func _ready():
	# connecting these buttons manually is fine for small test, need to use a singleton/signal
	# manager if implememented for large number of systems
	var sol_button = get_node("SwitchCurrentSystemButtons/Sol")
	sol_button.connect("system_selected", Callable(self, "_current_system_update"))
	
	var vega_button = get_node("SwitchCurrentSystemButtons/Vega")
	vega_button.connect("system_selected", Callable(self, "_current_system_update"))
	
	var alpha_button = get_node("SwitchCurrentSystemButtons/Alpha Centauri")
	alpha_button.connect("system_selected", Callable(self, "_current_system_update"))
	
	var helix_button = get_node("SwitchCurrentSystemButtons/Helix Station")
	helix_button.connect("system_selected", Callable(self, "_current_system_update"))
	
	var helix_ac_route = get_node("SwitchCurrentJumpButtons/helix station <-> alpha centauri")
	helix_ac_route.connect("route_selected", Callable(self, "_current_route_update"))
	
	var helix_vega_route = get_node("SwitchCurrentJumpButtons/vega <-> helix station")
	helix_vega_route.connect("route_selected", Callable(self, "_current_route_update"))
	
	var vega_sol_route = get_node("SwitchCurrentJumpButtons/sol <-> vega")
	vega_sol_route.connect("route_selected", Callable(self, "_current_route_update"))
	
	var vega_ac_route = get_node("SwitchCurrentJumpButtons/vega <-> alpha centauri")
	vega_ac_route.connect("route_selected", Callable(self, "_current_route_update"))
	update_highlights()

	# For systems
func highlight_system(system_node: Control, is_active: bool) -> void:
	var icon: TextureButton = system_node.get_node("Icon")
	if is_active:
		icon.texture_normal = ACTIVE_TEXTURE
	else:
		icon.texture_normal = DEFAULT_TEXTURE

func highlight_jump_line(line: Line2D, is_active: bool) -> void:
	if is_active:
		line.default_color = Color(1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1)
	

func update_highlights():
	for system in $SystemContainer.get_children():
		highlight_system(system, system.name==current_system)
	for line in $JumpLineContainer.get_children():
		highlight_jump_line(line, line.name == current_route)


func _current_system_update(system_name: String):
	current_system = system_name
	update_highlights()

func _current_route_update(route_name: String):
	current_route = route_name
	update_highlights()
