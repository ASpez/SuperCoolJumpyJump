extends Node2D


var vol: float = 0.0

onready var start_boss_fight: bool = false
onready var tween_out = get_node("MusicTween")
onready var camera_tween = $CameraTween

onready var bus_music = AudioServer.get_bus_index("Music")




func _process(delta: float) -> void:
	if not start_boss_fight:
		if $BossFight.is_colliding():
			start_boss_fight = true
			yield(get_tree().create_timer(.01), "timeout")
			get_tree().call_group_flags(2, "frame_freeze", "freeze")
			#var org_pos: Vector2 = $BossFightCamera.position
			var org_pos: Vector2 = Vector2(9744.0, 158.0)
			var new_pos: Vector2 = Vector2((org_pos - $Player.position).x, ($Player/Camera2D.position.y - org_pos.y))
			camera_transition($Player/Camera2D, new_pos)
			yield(get_tree().create_timer(2.2), "timeout")
			#$BossFightCamera.make_current()
			vol = $BossMusic.volume_db
			fade_out($Music)
			vol += 12
			fade_in($BossMusic)
			$Enemies/Boss/StartFight.play("fade_in")
			yield(get_tree().create_timer(2), "timeout")
			get_tree().call_group_flags(2, "frame_freeze", "freeze")
			get_tree().call_group_flags(2, "Boss", "set_start_boss_fight")
			$BossFight.enabled = false

func fade_out(stream_player):
	tween_out.interpolate_property(stream_player, "volume_db", vol, -80, 2, 0, Tween.EASE_IN, 0)
	tween_out.start()
	yield(tween_out, "tween_completed")
	stream_player.stop()

func fade_in(stream_player):
	stream_player.play()
	tween_out.interpolate_property(stream_player, "volume_db", -80, vol, 2, 0, Tween.EASE_IN, 0)
	tween_out.start()


func camera_transition(camera: Camera2D, new_pos: Vector2) -> void:
	camera_tween.interpolate_property(camera, "position", camera.position, new_pos, 2, 1, Tween.EASE_IN, 0)
	camera_tween.start()
	yield($CameraTween, "tween_all_completed")

func _on_Boss_dead() -> void:
	get_tree().call_group_flags(2, "frame_freeze", "freeze")
	$Player/Camera2D/SceenShake.start(2, 10, 30)
	yield(get_tree().create_timer(2.2), "timeout")
	camera_transition($Player/Camera2D, Vector2(0, -350))
	yield(get_tree().create_timer(2.2), "timeout")
	#$Player/Camera2D.make_current()
	get_tree().call_group_flags(2, "frame_freeze", "freeze")
	vol -= 12
	fade_out($BossMusic)
	$Secret.play()
	$TileMap2.set_collision_layer_bit(3, true)
	$TileMap2.visible = true
	fade_in($Music)

func _on_Boss_hit(hit_points) -> void:
	var duration = 0.2 * hit_points
	var frequency = 15 + (hit_points * 1.75)
	var amplitude = 20 + (hit_points * 2)
	var priority = 3
	$Player/Camera2D/SceenShake.start(duration, frequency, amplitude, priority)
