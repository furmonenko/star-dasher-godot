extends Area2D

signal picked_up

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.lives < 3:
			queue_free()
			emit_signal("picked_up")
