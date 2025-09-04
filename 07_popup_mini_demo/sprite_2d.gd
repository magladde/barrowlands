extends Sprite2D

var speed := 300

func _process(delta: float) -> void:
	position.x = position.x + speed * delta
