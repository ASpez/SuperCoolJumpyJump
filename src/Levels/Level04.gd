extends Node2D


func _ready() -> void:
	pass 
	
#func _process(delta: float) -> void:
#	pass


func _on_Boss_dead() -> void:
	$TileMap2.set_collision_layer_bit(3, true)
	$TileMap2.visible = true
