extends CharacterBody2D

@export var horizontal_speed: float = 220.0
@export var horizontal_acceleration: float = 500.0
@export var horizontal_drag: float = 350.0
@export var rise_speed: float = 180.0
@export var sink_speed: float = 100.0
@export var vertical_acceleration: float = 300.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * horizontal_speed, horizontal_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, horizontal_drag * delta)

	# Positive Y sinks; negative Y swims upward. Change speed gradually.
	var target_vertical_speed := sink_speed
	if Input.is_action_pressed("swim_up"):
		target_vertical_speed = -rise_speed
	velocity.y = move_toward(velocity.y, target_vertical_speed, vertical_acceleration * delta)

	move_and_slide()
