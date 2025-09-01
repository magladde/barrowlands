extends CharacterBody2D

@export var speed: float = 20_000.0 # Adjust this value for desired movement speed

func _physics_process(delta: float) -> void:
	# Get the input vector for 8-directional movement (including diagonals)
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Set the velocity based on the direction and speed
	velocity = direction * speed * delta

	# Move the character and handle collisions
	move_and_slide()
