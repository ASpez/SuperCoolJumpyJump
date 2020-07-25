extends Node2D




func _process(delta: float) -> void:

	if $Bewki.is_colliding():
		yield(get_tree().create_timer(30), "timeout")
		if $Bewki.is_colliding():
			$Secret.play()
			$TileMap2.set_collision_layer_bit(3, true)
			$TileMap2.visible = true
			get_node("Player/Camera2D").limit_top = -1250
			$Bewki.enabled = false
