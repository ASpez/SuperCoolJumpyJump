extends Button


func _on_SettingsButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1


func _on_SettingsButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0


func _on_SettingsButton_button_up() -> void:
	#get_tree().paused = true
	var root = get_tree().get_root()
	var main_scene = root.get_child(root.get_child_count() - 1)
	var current_scene = get_tree().get_current_scene().get_name()
	
	get_node("/root/" + current_scene + "/UserInterface/UserInterface").rect_size.y = 1080
	get_node("/root/" + current_scene + "/UserInterface/UserInterface/Settings").visible = true
	
	main_scene.modulate = Color("#20ffffff")
	
