extends Control


const PERFECT_SCORE: = 25100

onready var label: Label = get_node("Label")
onready var PerfectScore: Label = get_node("PerfectGame")
onready var bus_music: = AudioServer.get_bus_index("Music")

onready var _startPos: Vector2 = $PerfectGame/Particles3.position

var busdb_music = -21.0
var mute: bool

var t: float = 0.0
var speed: float = 1
var _showPart3: bool = false
var xscale: float = OS.window_size.x - 600
var yscale: float = OS.window_size.y / 4.0

onready var hs = load("res://src/Screens/highscore.gd").new()


func _ready() -> void:
	set_high_score_text(hs.load_high_scores())
	
	label.text = label.text % [PlayerData.score, PlayerData.deaths]
	AudioServer.set_bus_volume_db(bus_music, busdb_music)
	
	if PlayerData.deaths == 0:
		#get_node("PerfectGame/Particles1").visible = true
		#get_node("PerfectGame/Particles2").visible = true
		$Particles2D.amount += 100
		PerfectScore.text = "No Deaths!!"
		
		if PlayerData.score == PERFECT_SCORE:
			PerfectScore.text = "No Deaths and Perfect Score !!!"
			$Particles2D.amount += 150
			$PerfectGame/Particles3.emitting = true
			_showPart3 = true
			
		PerfectScore.visible = true
	
	if hs.is_high_score(PlayerData.score):
		$WindowDialog.popup_centered()


func _physics_process(delta: float) -> void:
	if _showPart3:
		$PerfectGame/Particles3.position = _startPos + (Vector2.RIGHT * sin(t/2*speed+0.2)*xscale - Vector2.UP * sin(t*speed)*yscale)
		t += delta
	
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
		
	if Input.is_key_pressed(KEY_H):
		$HighScoresLabel.visible = not $HighScoresLabel.visible


func set_high_score_text(highscores: Array) -> void:
	$HighScoresLabel.clear()
	var line: String = "[rainbow freq=0.3 sat=0.5 val=1]\n"
	var chunk: String = ""

	for i in range(10):
		chunk = highscores[i].name
		
		while chunk.length() < 25:
			chunk += "."
		
		line += chunk
		line += " Score - "
		
		chunk = String(highscores[i].score)
		var extra_space = 5 - chunk.length()
		
		for j in range(extra_space):
			line += "0"
			
		line += chunk
		line += " Deaths - "
		chunk = String(highscores[i].deaths)
		
		if chunk.length() == 1:
			line += "0"
		
		line += chunk
		
		if i == 0:
			line += "[/rainbow]"
			
		line += "\n"
		
	$HighScoresLabel.append_bbcode(line)
	
	
func _on_hs_ok_button_button_up() -> void:
	var name = $WindowDialog/hs_name.text
	
	hs.set_high_scores(name, PlayerData.score, PlayerData.deaths)
	hs.save_high_scores()
	
	set_high_score_text(hs.load_high_scores())
	
	$WindowDialog.hide()
	
	$HighScoresLabel.visible = true
