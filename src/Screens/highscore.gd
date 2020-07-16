extends Node

class Highscore:
	var name
	var score
	var deaths
	
	func _init(name, score, deaths):
		self.name = name
		self.score = score
		self.deaths = deaths

var highscores = []
var HIGH_SCORE_FILE = "user://scores.sav"


func load_high_scores() -> Array:
	var file = File.new()
	
	if not file.file_exists(HIGH_SCORE_FILE):
		create_default_file()  
	
	highscores.clear()
	file.open(HIGH_SCORE_FILE, file.READ)
	for i in range(10):
		var line = file.get_line().split(",")
		highscores.append(Highscore.new(line[0], line[1], line[2]))
	
	file.close()
	
	return highscores
	
func save_high_scores() -> void:
	var file = File.new()
	file.open(HIGH_SCORE_FILE, File.WRITE)
	for i in range(10):
		file.store_line(highscores[i].name + "," + String(highscores[i].score) + "," + String(highscores[i].deaths))
	file.close()

	
func is_high_score(score: int) -> bool:
	for h in highscores:
		if int(h.score) < score:
			return true
		
	return false
	
	
func set_high_scores(name: String, score: int, deaths: int) -> void:
	for i in range(highscores.size()):
		if int(highscores[i].score) < score:
			highscores.insert(i, Highscore.new(name, score, deaths))
			return


func create_default_file() -> void:
	var default_list = ["Samus O'Aaron,24500,0", "Tater Salad,20000,0", "Beafis,15000,0",
	"Mean Joe,10000,1", "Sonik,8000,1", "Duke Chochula,6000,1", "Chuck S. Cheese,4000,2",
	"Bob Evans,2000,2", "Curly,1000,4", "Bubba,100,99"]
	
	var file = File.new()
	file.open(HIGH_SCORE_FILE, file.WRITE)
	
	for i in range(10):
		file.store_line(default_list[i])
		
	file.close()
	
