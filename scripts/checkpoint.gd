extends Area2D

var activated: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not activated:
		activated = true
		body.respawn_position = global_position
		$Visual.color = Color(0.2, 1.0, 0.4, 0.8)
