extends Area2D

# World direction: (1, 0) is right; (0, -1) is up.
@export var direction: Vector2 = Vector2.RIGHT
# Added acceleration in pixels per second squared. Swimming still acts normally.
@export_range(0.0, 3000.0, 10.0) var strength: float = 180.0
# Maximum added current speed, in pixels per second.
# Keep horizontal currents below the player horizontal_speed to allow swimming against them.
@export_range(0.0, 1000.0, 10.0) var max_speed: float = 180.0


func _ready() -> void:
	$Arrow.rotation = direction.angle()


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not body.currents.has(self):
		body.currents.append(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.currents.erase(self)
