extends Node

var music: AudioStreamPlayer
var toggle_button: Button


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music = AudioStreamPlayer.new()
	music.stream = load("res://assets/nothing-on.mp3")
	music.volume_db = -10.0
	music.finished.connect(_restart_music)
	add_child(music)
	music.play()
	_create_toggle_button()


func _create_toggle_button() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 20
	add_child(layer)

	toggle_button = Button.new()
	toggle_button.text = "Pause Game"
	toggle_button.tooltip_text = "Pause or resume the game"
	# Keep Space reserved for the player's swim-up control.
	toggle_button.focus_mode = Control.FOCUS_NONE
	toggle_button.position = Vector2(800, 16)
	toggle_button.size = Vector2(140, 36)
	toggle_button.pressed.connect(_toggle_game)
	layer.add_child(toggle_button)


func _toggle_game() -> void:
	if get_tree().paused:
		get_tree().paused = false
		music.stream_paused = false
		toggle_button.text = "Pause Game"
	else:
		get_tree().paused = true
		music.stream_paused = true
		toggle_button.text = "Play Game"


func _restart_music() -> void:
	music.play()
