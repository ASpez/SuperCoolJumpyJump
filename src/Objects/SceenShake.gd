extends Node



const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()


func start(duration = 0.2, frequency = 15, amplitude = 20, priority = 0) -> void:
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()
	
		shake()

func shake() -> void:
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude/2, amplitude/2)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
func reset() -> void:
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0

func _on_Frequency_timeout() -> void:
	shake()

func _on_Duration_timeout() -> void:
	reset()
	$Frequency.stop()
