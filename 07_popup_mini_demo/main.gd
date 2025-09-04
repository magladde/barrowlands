extends Node2D

@onready var popup: PopupPanel = $PopupPanel
@onready var show_button = $Button
@onready var close_button = $PopupPanel/Node/Label/CloseButton

func _ready():
	popup.hide()
	show_button.connect("pressed", Callable(self, "_on_show_button_pressed"))
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	

func _on_show_button_pressed():
	print("button pressed")
	get_tree().paused = true
	popup.show()
	popup.popup_centered()


func _on_close_button_pressed():
	print("close button pressed")
	popup.hide()
	get_tree().paused = false
