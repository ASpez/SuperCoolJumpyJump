tool
extends Area2D

onready var snd_player: AudioStreamPlayer2D = $PortalSound
onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene: PackedScene

var is_teleporting: bool = false

onready var pd = get_node("../Player")

func _on_body_entered(_body: Node) -> void:
	if is_teleporting == false:
		is_teleporting = true
		PlayerData.is_teleporting = true
		teleport()
	

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty" if not next_scene else ""


func teleport() -> void:
	snd_player.play()
	anim_player.play("fade_in")
	#yield(snd_player,"finished")
	yield(anim_player, "animation_finished")
	PlayerData.level += 1
	if pd.has_shield:
		PlayerData.score += 100
	get_tree().change_scene_to(next_scene)
	PlayerData.is_teleporting = false
