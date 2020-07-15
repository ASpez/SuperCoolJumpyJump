extends Node2D


onready var bus_effects: = AudioServer.get_bus_index("Effects")



func _ready() -> void:
	AudioServer.set_bus_effect_enabled(bus_effects, 0, true)
