extends Node2D


onready var enter_cave_ray = $EnterCave
onready var exit_cave_ray = $ExitCave
onready var bus_effects: = AudioServer.get_bus_index("Effects")
onready var player = $Player

var lastvol: int = 0

func _process(delta: float) -> void:
	pass
	#if enter_cave_ray.is_colliding() == true:
	#	AudioServer.set_bus_effect_enabled(bus_effects, 0, true)
	#if exit_cave_ray.is_colliding() == true:
	#	AudioServer.set_bus_effect_enabled(bus_effects, 0, false)
