extends Node2D

# Generous first-playtest budget; tune after timing a complete run.
@export_range(1.0, 600.0, 1.0, "or_greater", "suffix:s") var oxygen_duration: float = 420.0

var oxygen_remaining: float
var completed: bool = false


func _ready() -> void:
	oxygen_remaining = oxygen_duration
	update_oxygen_display()


func _process(delta: float) -> void:
	if completed:
		return

	oxygen_remaining = maxf(oxygen_remaining - delta, 0.0)
	if oxygen_remaining <= 0.0:
		# A failed attempt restarts at the latest checkpoint with a fresh countdown.
		$Player.respawn()
		oxygen_remaining = oxygen_duration
		$HUD/RetryMessage.show()
		$RetryMessageTimer.start()
	update_oxygen_display()


func update_oxygen_display() -> void:
	$HUD/OxygenBar.value = oxygen_remaining / oxygen_duration * 100.0
	$HUD/OxygenTime.text = "Oxygen: %d s remaining" % ceili(oxygen_remaining)


func _on_surface_body_entered(body: Node2D) -> void:
	if body is Player and not completed:
		completed = true
		$HUD/RetryMessage.hide()
		$HUD/Completion.show()
		get_tree().paused = true


func _on_retry_message_timer_timeout() -> void:
	$HUD/RetryMessage.hide()
