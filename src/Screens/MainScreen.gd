extends Control


onready var bus_music: = AudioServer.get_bus_index("Music")
onready var bus_master: = AudioServer.get_bus_index("Master")
onready var anim_title: AnimationPlayer = $TitleAnimation
onready var busdb_music = -21.0

var mute: bool

var rng = RandomNumberGenerator.new()
var rand: Vector2

var _movePB: bool = true
var _moveIB: bool = true
var _moveQB: bool = true


func _ready() -> void:
	PlayerData.load_settings()
	OS.center_window()
	rng.randomize()
	$Version.text = "Version: %s" % PlayerData.VERSION
	AudioServer.set_bus_volume_db(bus_music, busdb_music)
	
	if PlayerData.option_enable_audio:
		AudioServer.set_bus_mute(bus_master, false)
	else:
		AudioServer.set_bus_mute(bus_master, true)
		
	if not PlayerData.option_enable_particles:
		$Particles2D.emitting = false
	
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

	
func _on_Timer_timeout() -> void:
	rand = Vector2(rng.randi_range(-5, 5), rng.randi_range(15, 30))
	$Particles2D.process_material.gravity = Vector3(rand.x, rand.y, 0)


func _on_TimerButtonFlip_timeout() -> void:
	rng.randomize()
	_movePB = rng.randi_range(0, 1)
	#rng.randomize()
	_moveIB = rng.randi_range(0, 1)
	#rng.randomize()
	_moveQB = rng.randi_range(0, 1)
	
	var _btn_anim = $ButtonAnimation.get_animation("ButtonFlip")
	var _pbTrack = _btn_anim.find_track("Menu/PlayButton:rect_rotation")
	var _ibTrack = _btn_anim.find_track("Menu/InfoButton:rect_rotation")
	var _qbTrack = _btn_anim.find_track("Menu/QuitButton:rect_rotation")
	
	if _movePB:
		_btn_anim.track_set_enabled(_pbTrack, true)
	if _moveIB:
		_btn_anim.track_set_enabled(_ibTrack, true)
	if _moveQB:
		_btn_anim.track_set_enabled(_qbTrack, true)
	
	if rng.randi_range(0, 1):
		$ButtonAnimation.play("ButtonFlip")
	else:
		$ButtonAnimation.play_backwards("ButtonFlip")
	
	$TimerButtonFlip.wait_time = 15	
	$TimerButtonFlip.start()
	
	
	
	
	
