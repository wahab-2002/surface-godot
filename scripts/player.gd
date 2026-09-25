class_name Player
extends CharacterBody2D

signal respawned

@export var horizontal_speed: float = 220.0
@export var horizontal_acceleration: float = 500.0
@export var horizontal_drag: float = 350.0
# Slower drag for horizontal momentum gained from currents, in pixels per second squared.
@export_range(0.0, 500.0, 5.0) var post_current_horizontal_drag: float = 40.0
@export var rise_speed: float = 180.0
@export var sink_speed: float = 100.0
@export var vertical_acceleration: float = 300.0
# Drag on vertical current momentum after leaving an area, in pixels per second squared.
@export_range(0.0, 500.0, 5.0) var post_current_vertical_drag: float = 100.0

var respawn_position: Vector2
var currents: Array[Area2D] = []
var swimming_velocity: Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	respawn_position = global_position


func respawn() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	swimming_velocity = Vector2.ZERO
	current_velocity = Vector2.ZERO
	currents.clear()
	respawned.emit()


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		swimming_velocity.x = move_toward(swimming_velocity.x, direction * horizontal_speed, horizontal_acceleration * delta)
	else:
		swimming_velocity.x = move_toward(swimming_velocity.x, 0.0, horizontal_drag * delta)

	# Positive Y sinks; negative Y swims upward. Change speed gradually.
	var target_vertical_speed := sink_speed
	if Input.is_action_pressed("swim_up"):
		target_vertical_speed = -rise_speed
	swimming_velocity.y = move_toward(swimming_velocity.y, target_vertical_speed, vertical_acceleration * delta)

	# Build a separate current velocity so swimming can still oppose the flow.
	var target_current_velocity := Vector2.ZERO
	var current_acceleration := 0.0
	for current in currents:
		target_current_velocity += current.direction.normalized() * current.max_speed
		current_acceleration = maxf(current_acceleration, current.strength)

	if not currents.is_empty():
		current_velocity = current_velocity.move_toward(target_current_velocity, current_acceleration * delta)
	else:
		# Leaving stops acceleration, but underwater drag takes time to remove momentum.
		current_velocity.x = move_toward(current_velocity.x, 0.0, post_current_horizontal_drag * delta)
		current_velocity.y = move_toward(current_velocity.y, 0.0, post_current_vertical_drag * delta)

	velocity = swimming_velocity + current_velocity
	move_and_slide()
	# Stop both kinds of momentum into walls, keeping movement along the wall.
	for index in get_slide_collision_count():
		var normal := get_slide_collision(index).get_normal()
		if swimming_velocity.dot(normal) < 0.0:
			swimming_velocity = swimming_velocity.slide(normal)
		if current_velocity.dot(normal) < 0.0:
			current_velocity = current_velocity.slide(normal)
