extends Button


export(String, FILE) var next_scene_path: = ""


func _on_button_up() -> void:
	PlayerData.reset()
	get_tree().paused = false
	get_tree().change_scene(next_scene_path)


func _get_configuration_warning() -> String:
	return "next_scene_path NOT set!" if next_scene_path == "" else ""


func _on_PlayButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1
	

func _on_PlayButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0


func _on_ChangeSceneButton_mouse_entered() -> void:
	rect_scale.x = 1.1
	rect_scale.y = 1.1


func _on_ChangeSceneButton_mouse_exited() -> void:
	rect_scale.x = 1.0
	rect_scale.y = 1.0
