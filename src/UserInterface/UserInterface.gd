extends Control


onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var score: Label = get_node("Score")
onready var level: Label = get_node("Level")
onready var pause_title: Label = get_node("PauseOverlay/Title")
onready var bus_music: = AudioServer.get_bus_index("Music")
onready var bus_effects: = AudioServer.get_bus_index("Effects")
onready var bus_master: = AudioServer.get_bus_index("Master")


var paused: = false setget set_paused
var busdb_music
var busdb_effects
var mute: bool
var mute_level: int


func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	$MusicVolume.value = AudioServer.get_bus_volume_db(bus_music)
	$EffectsVolume.value = AudioServer.get_bus_volume_db(bus_effects)
	update_interface()
	
	if not PlayerData.option_enable_audio:
		set_audio_mute("All", true)


func _physics_process(delta: float) -> void:
	check_buffs()
	if not PlayerData.option_enable_audio:
		set_audio_mute("All", true)
		
	if PlayerData.option_enable_audio and $MusicOnButton.visible == true and $SFXOnButton.visible == true:
		set_audio_mute("All", false)
		
func set_audio_mute(audio_type: String, _mute: bool) -> void:
	match audio_type:
		"Music", "All":
			AudioServer.set_bus_mute(bus_music, _mute)
			continue
		"Effects", "All":
			AudioServer.set_bus_mute(bus_effects, _mute)


func check_buffs() -> void:
	if PlayerData.buff_double_shield:
		$ShieldBuff.visible = true
	else:
		$ShieldBuff.visible = false
	
	if PlayerData.buff_jump_boost:
		$JumpBuff.visible = true
	else:
		$JumpBuff.visible = false
		
	if PlayerData.buff_speed_boost:
		$SpeedBuff.visible = true
	else:
		$SpeedBuff.visible = false


func _on_PlayerData_player_died() -> void:
	self.paused = true
	pause_title.text = "You died!"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and pause_title.text != "You died!":
		self.paused = not paused
		scene_tree.set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volup"):
		busdb_music = AudioServer.get_bus_volume_db(bus_music) + 3.0
		if busdb_music > 5.0:
			busdb_music = 6.0
		AudioServer.set_bus_volume_db(bus_music, busdb_music)
		$MusicVolume.value = busdb_music
		show_music_vol_meter()

	if event.is_action_pressed("voldown"):
		busdb_music = AudioServer.get_bus_volume_db(bus_music) - 3.0
		if busdb_music < -51.0:
			busdb_music = -51.0
		AudioServer.set_bus_volume_db(bus_music, busdb_music)
		$MusicVolume.value = busdb_music
		show_music_vol_meter()

	if event.is_action_pressed("volup_sfx"):
		busdb_effects = AudioServer.get_bus_volume_db(bus_effects) + 3.0
		AudioServer.set_bus_volume_db(bus_effects, busdb_effects)
		$EffectsVolume.value = busdb_effects
		show_effects_vol_meter()

	if event.is_action_pressed("voldown_sfx"):
		busdb_effects = AudioServer.get_bus_volume_db(bus_effects) - 3.0
		AudioServer.set_bus_volume_db(bus_effects, busdb_effects)
		$EffectsVolume.value = busdb_effects
		show_effects_vol_meter()

	if event.is_action_pressed("mute_audio"):
		mute_level = mute_level % 3
		match mute_level:
			0:
				AudioServer.set_bus_mute(bus_music, true)
			1:
				AudioServer.set_bus_mute(bus_effects, true)
			2:
				AudioServer.set_bus_mute(bus_music, false)
				AudioServer.set_bus_mute(bus_effects, false)
				AudioServer.set_bus_mute(bus_master, false)

		mute_level += 1
		

func show_music_vol_meter() -> void:
	if $MusicTimer.is_stopped():
		$MusicVolume.visible = true
		
	$MusicTimer.wait_time = 3.0
	$MusicTimer.start()
	
	
func show_effects_vol_meter() -> void:
	if $EffectsTimer.is_stopped():
		$EffectsVolume.visible = true
		
	$EffectsTimer.wait_time = 3.0
	$EffectsTimer.start()
	
		
func update_interface() -> void:
	score.text = "Score: %s" % PlayerData.score
	level.text = "Level: %s" % PlayerData.level
	
	
func set_paused(value: bool ) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value


func _on_MusicTimer_timeout() -> void:
	$MusicVolume.visible = false


func _on_EffectsTimer_timeout() -> void:
	$EffectsVolume.visible = false


func _on_MusicOnButton_button_up() -> void:
	$MusicOnButton.visible = false
	$MusicOffButton.visible = true
	set_audio_mute("Music", true)


func _on_MusicOffButton_button_up() -> void:
	$MusicOnButton.visible = true
	$MusicOffButton.visible = false
	set_audio_mute("Music", false)


func _on_SFXOnButton_button_up() -> void:
	$SFXOnButton.visible = false
	$SFXOffButton.visible = true
	set_audio_mute("Effects", true)


func _on_SFXOffButton_button_up() -> void:
	$SFXOnButton.visible = true
	$SFXOffButton.visible = false
	set_audio_mute("Effects", false)


func _on_SettingsButton_button_up() -> void:
	pass # Replace with function body.


func _on_MusicOnButton_mouse_entered() -> void:
	$MusicOnButton.modulate = Color("#8d98b2")
	

func _on_MusicOnButton_mouse_exited() -> void:
	$MusicOnButton.modulate = Color("#648d98b2")


func _on_MusicOffButton_mouse_entered() -> void:
	$MusicOffButton.modulate = Color("#8d98b2")


func _on_MusicOffButton_mouse_exited() -> void:
	$MusicOffButton.modulate = Color("#648d98b2")


func _on_SFXOnButton_mouse_entered() -> void:
	$SFXOnButton.modulate = Color("#8d98b2")


func _on_SFXOffButton_mouse_entered() -> void:
	$SFXOffButton.modulate = Color("#8d98b2")


func _on_SFXOnButton_mouse_exited() -> void:
	$SFXOnButton.modulate = Color("#648d98b2")


func _on_SFXOffButton_mouse_exited() -> void:
	$SFXOffButton.modulate = Color("#648d98b2")


func _on_SettingsButton_mouse_entered() -> void:
	$SettingsButton.modulate = Color("#8d98b2")


func _on_SettingsButton_mouse_exited() -> void:
	$SettingsButton.modulate = Color("#648d98b2")
