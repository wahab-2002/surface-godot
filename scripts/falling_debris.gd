extends Node2D

@export_range(0.4, 3.0, 0.1, "suffix:s") var warning_time: float = 1.0
@export_range(50.0, 500.0, 10.0) var fall_speed: float = 240.0
@export_range(100.0, 800.0, 10.0) var fall_distance: float = 360.0

var activated: bool = false
var falling: bool = false


func _ready() -> void:
	$DropColumn.points = PackedVector2Array([Vector2(0, 20), Vector2(0, fall_distance)])
	reset()


func _physics_process(delta: float) -> void:
	if not $WarningTimer.is_stopped():
		# Flash the block before it moves; the column shows its drop path.
		$Debris/Visual.color = Color.ORANGE if int($WarningTimer.time_left * 8) % 2 == 0 else Color.YELLOW
	if falling:
		$Debris.position.y = minf($Debris.position.y + fall_speed * delta, fall_distance)
		if $Debris.position.y >= fall_distance:
			falling = false


func _on_trigger_body_entered(body: Node2D) -> void:
	if body is Player and not activated:
		if not body.respawned.is_connected(reset):
			body.respawned.connect(reset)
		activated = true
		$WarningTimer.start(warning_time)


func _on_warning_timer_timeout() -> void:
	if not activated:
		return
	falling = true
	$Debris/Visual.color = Color(1.0, 0.15, 0.2)
	$Debris.set_deferred("monitoring", true)


func reset() -> void:
	activated = false
	falling = false
	$WarningTimer.stop()
	$Debris.position = Vector2.ZERO
	$Debris.set_deferred("monitoring", false)
	$Debris/Visual.color = Color.ORANGE
