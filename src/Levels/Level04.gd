extends Node2D



onready var start_boss_fight: bool = false


func _process(delta: float) -> void:
	if not start_boss_fight:
		if $BossFight.is_colliding():
			start_boss_fight = true
			get_tree().call_group_flags(2, "Boss", "set_start_boss_fight")
			$BossFight.enabled = false

func _on_Boss_dead() -> void:
	$Secret.play()
	$TileMap2.set_collision_layer_bit(3, true)
	$TileMap2.visible = true
