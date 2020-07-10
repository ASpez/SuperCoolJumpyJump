extends Button


func _on_button_up() -> void:
	PlayerData.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_RetryButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1


func _on_RetryButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0
