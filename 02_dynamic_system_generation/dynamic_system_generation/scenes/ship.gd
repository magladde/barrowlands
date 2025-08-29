extends CharacterBody2D

@export var thrust := 400.0
@export var rotation_speed := 10.0
@export var friction := 5.0
@export var brake_strength := 300
@export var tween_rotate_time := 3

var braking := false

func _ship_movement(delta):
	braking = false
	if Input.is_action_pressed("turn_left"):
		rotation =  rotation - rotation_speed * delta
	
	if Input.is_action_pressed("turn_right"):
		rotation = rotation + rotation_speed * delta
	
	if Input.is_action_pressed("thrust"):
		velocity = velocity + (Vector2.UP.rotated(rotation) * thrust * delta)
		
	if Input.is_action_pressed("brake"):
		braking = true

	if braking:
		velocity = velocity.move_toward(Vector2.ZERO, brake_strength * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _physics_process(delta: float) -> void:
	_ship_movement(delta)
	move_and_slide()
