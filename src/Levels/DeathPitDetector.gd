extends RayCast2D



func _process(delta: float) -> void:
	if is_colliding():
		# No need to test, node can only collide with a player
		get_tree().call_group_flags(2, "Player", "die")

