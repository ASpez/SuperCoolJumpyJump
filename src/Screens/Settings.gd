extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Options/Option_God_mode.pressed = PlayerData.option_god_mode
	$Options/Option_enable_audio.pressed = PlayerData.option_enable_audio
	$Options/Option_enable_shields.pressed = PlayerData.option_enable_shields
	$Options/Option_enable_particles.pressed = PlayerData.option_enable_particles


func _on_Option_God_mode_button_up() -> void:
	PlayerData.option_god_mode = $Options/Option_God_mode.pressed


func _on_Option_enable_shields_button_up() -> void:
	PlayerData.option_enable_shields = $Options/Option_enable_shields.pressed


func _on_Option_enable_audio_button_up() -> void:
	PlayerData.option_enable_audio = $Options/Option_enable_audio.pressed


func _on_Option_enable_particles_button_up() -> void:
	PlayerData.option_enable_particles = $Options/Option_enable_particles.pressed


func _on_SaveButton_button_up() -> void:
	PlayerData.save_settings()

