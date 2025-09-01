extends Node2D

@onready var btn: Button = $UI/Button
@onready var trigger: Area2D = $Trigger

signal landed(planet_name: String)

func _ready() -> void:
	# connect signal from button to _on_button_pressed function
	btn.pressed.connect(_on_button_pressed)
	
	# connect signal from body entering trigger node
	trigger.body_entered.connect(_on_body_entered_trigger)
	
	# connect custom landed signal
	landed.connect(_on_landed)
	
	
func _on_button_pressed():
	print("button pressed")

func _on_body_entered_trigger(body: Node2D) -> void:
	if body.name != "Ship":
		pass
	print("something entered the collision shape")
	# emit a signal "landed" and pass the planet_name argument
	emit_signal("landed", "Demo Planet")
	
func _on_landed(planet_name: String) -> void:
	print("custom signal recieved: landed on %s" % planet_name)
	
