extends Node



signal score_updated
signal player_died
signal level_updated

var score: = 0 setget set_score
var deaths: = 0 setget set_deaths
var level: = 1 setget set_level

const VERSION = "v0.0.34"


func reset() -> void:
	score = 0
	deaths = 0
	level = 1
	
	
func set_level(value: int) -> void:
	level = value
	emit_signal("level_updated")
	

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")
	
	
func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")
	

