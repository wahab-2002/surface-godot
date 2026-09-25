extends Area2D

var transitioning: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not transitioning:
		transitioning = true
		# Change scenes after the physics overlap callback finishes.
		get_tree().change_scene_to_file.call_deferred("res://scenes/level_2.tscn")
