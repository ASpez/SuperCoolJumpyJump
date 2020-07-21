extends Node2D


var vol: float = 0.0

onready var start_boss_fight: bool = false
onready var tween_out = get_node("Tween")

onready var bus_music = AudioServer.get_bus_index("Music")


func _process(delta: float) -> void:
	if not start_boss_fight:
		if $BossFight.is_colliding():
			$CameraMover.play("slide_in")
			start_boss_fight = true
			vol = $BossMusic.volume_db
			fade_out($Music)
			vol += 12
			fade_in($BossMusic)
			yield(get_tree().create_timer(2), "timeout")
			get_tree().call_group_flags(2, "Boss", "set_start_boss_fight")
			$BossFight.enabled = false

func fade_out(stream_player):
	tween_out.interpolate_property(stream_player, "volume_db", vol, -80, 2, 0, Tween.EASE_IN, 0)
	tween_out.start()
	yield($Tween, "tween_completed")
	stream_player.stop()

func fade_in(stream_player):
	stream_player.play()
	tween_out.interpolate_property(stream_player, "volume_db", -80, vol, 2, 0, Tween.EASE_IN, 0)
	tween_out.start()

func _on_Boss_dead() -> void:
	vol -= 12
	fade_out($BossMusic)
	$Secret.play()
	$TileMap2.set_collision_layer_bit(3, true)
	$TileMap2.visible = true
	fade_in($Music)
	$CameraMover.play("slide_out")
