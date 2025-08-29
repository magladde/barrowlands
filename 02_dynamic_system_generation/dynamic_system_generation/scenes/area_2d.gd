extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("body entered jump point")
	if body.name == "Ship":
		print("good to warp")
		emit_signal("jump_requested", "sol")
	else:
		print("must be some other object")
