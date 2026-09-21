extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Wait until the physics overlap callback finishes before teleporting.
		body.respawn.call_deferred()
