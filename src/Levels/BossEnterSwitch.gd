extends RayCast2D



func _process(delta: float) -> void:
	if is_colliding():
		enabled = false
		get_tree().call_group_flags(2, "Player", "level_8_boss_drop_enter")
