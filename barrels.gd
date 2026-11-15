extends Area2D

var direction := Vector2.LEFT
var speed := 300.0
var bounced := false


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage()
		queue_free()

	elif body.is_in_group("left_wall") and not bounced:
		bounced = true
		direction = Vector2.RIGHT

	elif body.is_in_group("right_wall") and bounced:
		queue_free()


# Optional safety net: connect a VisibleOnScreenNotifier2D screen_exited signal
func _on_screen_exited() -> void:
	queue_free()
