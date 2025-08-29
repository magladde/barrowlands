extends Control

@onready var SystemScene: PackedScene = load("res://scenes/system.tscn")

func _ready() -> void:
	$HBoxContainer/LeftButtons/BarButton.connect("pressed", Callable(self, "_on_button_Bar"))
	$HBoxContainer/LeftButtons/TradingButton.connect("pressed", Callable(self, "_on_button_Trading"))
	$HBoxContainer/RightButtons/RefuelButton.connect("pressed", Callable(self, "_on_button_Refuel"))
	$HBoxContainer/RightButtons/TakeoffButton.connect("pressed", Callable(self, "_on_button_Takeoff"))

func _on_button_Bar():
	$HBoxContainer/CentralVBox/ContentLabel/Label.text = "Welcome to the bar!"

func _on_button_Trading():
	$HBoxContainer/CentralVBox/ContentLabel/Label.text = "Trading post is closed for now, come back soon!"
	
func _on_button_Refuel():
	$HBoxContainer/CentralVBox/ContentLabel/Label.text = "Your ship seems full, and no one is here."
	
func _on_button_Takeoff():
	get_tree().change_scene_to_packed(SystemScene)
