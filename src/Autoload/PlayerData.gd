extends Node


signal score_updated
signal player_died
signal level_updated

var score: = 0 setget set_score
var deaths: = 0 setget set_deaths
var level: = 1 setget set_level

var option_god_mode: bool
var option_enable_shields: bool
var option_enable_audio: bool
var option_enable_particles: bool

var buff_double_shield: bool = false
var buff_speed_boost: bool = false
var buff_jump_boost: bool = false

var can_get_jump_boost: bool = true
var can_get_speed_boost: bool = true
var can_get_shield_boost: bool = true

var config = ConfigFile.new()

const VERSION = "v0.0.39"
const CFG_FILE = "user://settings.cfg"


func _ready() -> void:
	load_settings()


func reset() -> void:
	score = 0
	deaths = 0
	level = 1
	

func load_settings() -> void:
	if config.load(CFG_FILE) == OK:
		option_god_mode = config.get_value("Options", "Godmode", false)
		option_enable_shields = config.get_value("Options", "EnableShields", true)
		option_enable_audio = config.get_value("Options", "EnableAudio", true)
		option_enable_particles = config.get_value("Options", "EnableParticles", true)
	else:
		config.set_value("Options", "Godmode", false)
		config.set_value("Options", "EnableShields", true)
		config.set_value("Options", "EnableAudio", true)
		config.set_value("Options", "EnableParticles", true)
		config.save(CFG_FILE)


func save_settings() -> void:
	config.load(CFG_FILE)
	config.set_value("Options", "Godmode", PlayerData.option_god_mode)
	config.set_value("Options", "EnableShields", PlayerData.option_enable_shields)
	config.set_value("Options", "EnableAudio", PlayerData.option_enable_audio)
	config.set_value("Options", "EnableParticles", PlayerData.option_enable_particles)
	config.save(CFG_FILE)
		
func set_level(value: int) -> void:
	level = value
	emit_signal("level_updated")
	

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")
	
	
func set_score(value: int) -> void:
	if score > 100:
		score = value
		emit_signal("score_updated")
	

