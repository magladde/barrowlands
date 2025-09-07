extends CharacterBody2D
@export var thrust := 400.0
@export var max_speed := 1000.0
@export var rotation_speed := 10.0
@export var friction := 2.0
@export var brake_strength := 300

var braking := false
var speed := 0.0

func _physics_process(delta):
	speed = velocity.length()
	##### ship movement #####
	
	# flag to handle breaking
	braking = Input.is_action_pressed("reverse_thrust")

	# user input for turning
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# user input for thrust
	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation) * thrust * delta

	# slow ship down with either of these two methods
	if braking:
		velocity = velocity.move_toward(Vector2.ZERO, brake_strength * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# Apply velocity to position
	move_and_slide()
