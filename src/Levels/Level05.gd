extends Node2D


onready var bus_effects: = AudioServer.get_bus_index("Effects")
onready var player = $Player



func _process(delta: float) -> void:
	if player.position.y > 960:
		AudioServer.set_bus_effect_enabled(bus_effects, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(bus_effects, 0, false)
