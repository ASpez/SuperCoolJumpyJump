extends Area2D


onready var snd_player: AudioStreamPlayer2D = $CoinSound
onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")

export var score: = 100

var is_picked: bool = false

var effect_bus_to_use = "Effects"


func _ready() -> void:
	if PlayerData.level == 6:
		effect_bus_to_use = "Echo"


func _process(delta: float) -> void:
	if PlayerData.level == 5 and self.position.y > 950:
		effect_bus_to_use = "Echo"
	if PlayerData.level == 5 and self.position.y < 950:
		effect_bus_to_use = "Effects"


func _on_body_entered(_body: Node) -> void:
	if is_picked == false:
		is_picked = true
		picked()
	
	
func picked() -> void:
	PlayerData.score += self.score
	#snd_player.play()
	play_effect(snd_player, effect_bus_to_use, false)
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")


func play_effect(stream: AudioStreamPlayer2D, effect_bus: String, should_yield: bool) -> void:
	stream.bus = effect_bus
	stream.play()
	if should_yield:
		yield(stream, "finished")
