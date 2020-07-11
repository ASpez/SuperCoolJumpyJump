extends Control


var option_god_mode: bool = true
var option_enable_shields: bool = true
var option_enable_audio: bool = false
var option_enable_particles: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_Option_God_mode_button_up() -> void:
	option_god_mode = $Options/Option_God_mode.pressed


func _on_Option_enable_shields_button_up() -> void:
	option_enable_shields = $Options/Option_enable_shields.pressed


func _on_Option_enable_audio_button_up() -> void:
	option_enable_audio = $Options/Option_enable_audio.pressed


func _on_Option_enable_particles_button_up() -> void:
	option_enable_particles = $Options/Option_enable_particles.pressed
