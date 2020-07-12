extends Button



func _on_button_up() -> void:

	var root = get_tree().get_root()
	var main_scene = root.get_child(root.get_child_count() - 1)
	var current_scene = get_tree().get_current_scene().get_name()
	
	get_node("/root/" + current_scene + "/UserInterface/UserInterface").rect_size.y = 0
	get_node("/root/" + current_scene + "/UserInterface/UserInterface/Settings").visible = false
	main_scene.modulate = Color("#ffffff")
	
	get_tree().paused = false


func _on_BackButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1


func _on_BackButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0
