extends Control


onready var bus_music: = AudioServer.get_bus_index("Music")

var busdb_music = -21.0
var mute: bool


func _ready() -> void:
	$Version.text = "Version: %s" % PlayerData.VERSION
	AudioServer.set_bus_volume_db(bus_music, busdb_music)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volup"):
		busdb_music = AudioServer.get_bus_volume_db(bus_music) + 3.0
		AudioServer.set_bus_volume_db(bus_music, busdb_music)
			
	if event.is_action_pressed("voldown"):
		busdb_music = AudioServer.get_bus_volume_db(bus_music) - 3.0
		AudioServer.set_bus_volume_db(bus_music, busdb_music)
		
	if event.is_action_pressed("mute_audio"):
		mute = AudioServer.is_bus_mute(bus_music)
		mute = not mute
		AudioServer.set_bus_mute(bus_music, mute)


func _on_Info_meta_clicked(meta) -> void:
	OS.shell_open(meta)
