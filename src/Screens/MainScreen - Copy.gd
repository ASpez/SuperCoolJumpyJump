extends Control


onready var bus_music: = AudioServer.get_bus_index("Music")
onready var anim_title: AnimationPlayer = $TitleAnimation
onready var busdb_music = -21.0

var mute: bool

var rng = RandomNumberGenerator.new()
var rand: Vector2
var t: float = 0.0
var u: float = 0.0
var v: float = 0.0
var speed: float = 1
var xscale: float = 300.0
var yscale: float = 100.0
var _startPosPB: Vector2
var _startPosIB: Vector2
var _startPosQB: Vector2
var _movePB: bool = false
var _moveIB: bool = false
var _moveQB: bool = false

func _ready() -> void:
	OS.center_window()
	rng.randomize()
	$Version.text = "Version: %s" % PlayerData.VERSION
	AudioServer.set_bus_volume_db(bus_music, busdb_music)
	_startPosPB = $Menu/PlayButton.rect_position
	_startPosIB = $Menu/InfoButton.rect_position
	_startPosQB = $Menu/QuitButton.rect_position
	yield(get_tree().create_timer(30), "timeout")
	_movePB = true
	yield(get_tree().create_timer(30), "timeout")
	_moveIB = true
	yield(get_tree().create_timer(30), "timeout")
	_moveQB = true
	
	
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


func _physics_process(delta: float) -> void:
	if _movePB:
		$Menu/PlayButton.rect_position = _startPosPB + (Vector2.RIGHT * sin(t/2*speed+0.2)*xscale - Vector2.UP * sin(t*speed)*yscale)
		#$Menu/PlayButton.rect_position = _startPosPB + (Vector2.RIGHT * sin(OS.get_ticks_msec()/2*speed)*xscale - Vector2.UP * sin(OS.get_ticks_msec()*speed)*yscale)
		t += delta
	if _moveIB:
		#$Menu/InfoButton.rect_position = _startPosIB + (Vector2.LEFT * sin(OS.get_ticks_msec()/2*speed)*xscale - Vector2.UP * sin(OS.get_ticks_msec()*speed)*yscale)
		$Menu/InfoButton.rect_position = _startPosIB + (Vector2.LEFT * sin(u/2*speed+0.5)*xscale - Vector2.UP * sin(u*speed)*yscale)
		u += delta
	if _moveQB:
		#$Menu/QuitButton.rect_position = _startPosQB + (Vector2.RIGHT * sin(OS.get_ticks_msec()/2*speed)*(xscale+ 75.0) - Vector2.UP * sin(OS.get_ticks_msec()*speed)*yscale)
		$Menu/QuitButton.rect_position = _startPosQB + (Vector2.RIGHT * sin(v/2*speed)*(xscale+ 75.0) - Vector2.UP * sin(v*speed)*yscale)
		v += delta
	
func _on_Timer_timeout() -> void:
	rand = Vector2(rng.randi_range(-5, 5), rng.randi_range(15, 30))
	$Particles2D.process_material.gravity = Vector3(rand.x, rand.y, 0)
