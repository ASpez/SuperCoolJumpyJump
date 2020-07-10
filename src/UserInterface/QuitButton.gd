extends Button



func _on_button_up() -> void:
	get_tree().quit()


func _on_QuitButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1


func _on_QuitButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0
