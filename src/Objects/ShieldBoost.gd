extends Area2D


onready var snd_player: AudioStreamPlayer2D = $CoinSound
onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")


var is_picked: bool = false

func _on_body_entered(_body: Node) -> void:
	if anim_player.current_animation == "Appear":
		return
	if is_picked == false:
		is_picked = true
		picked()
	
	
func picked() -> void:
	PlayerData.buff_double_shield = true
	PlayerData.can_get_shield_boost = false
	snd_player.play()
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	self.position = Vector2(0,0)
	is_picked = false
