extends Area2D


onready var snd_player: AudioStreamPlayer2D = $CoinSound
onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")

export var score: = 100

var is_picked: bool = false

func _on_body_entered(_body: Node) -> void:
	if is_picked == false:
		is_picked = true
		picked()
	
	
func picked() -> void:
	PlayerData.score += self.score
	snd_player.play()
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
