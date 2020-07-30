extends Node2D

var vol: float = 0.0
var swap: bool = true
var boss_buddy_scene = preload("res://src/Actors/BossBuddy.tscn")

onready var tween_out = get_node("MusicTween")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vol = $BossMusic.volume_db
	vol += 12
	fade_in($BossMusic)
	yield(get_tree().create_timer(5),"timeout")
	get_tree().call_group_flags(2, "Boss", "set_start_boss_fight")
	$BlockSpawner.start()


func _on_Boss2_spawn(spawn_number, boss_position) -> void:
	var arry = []
	var rng = RandomNumberGenerator.new()
	for i in spawn_number:
		randomize()
		var rand1: Vector2 = Vector2(rng.randf_range(250, 350), rng.randf_range(-250, -400))
		boss_position = $Boss2.position
		if boss_position.x + (rand1.x * 2) + 100 >= $Player/Camera2D.limit_right:
			rand1.x *= -1
		var spawn = boss_buddy_scene.instance()
		add_child(spawn, true)
		$BossBuddySpawnSound.play()
		var sp = spawn.find_node("BossBuddySprite")
		arry.append(Tween.new())
		add_child(arry[i])
		arry[i].interpolate_property(spawn, "position", boss_position, boss_position + rand1, 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
		arry[i].interpolate_property(sp, "rotation_degrees", 0, 1440, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		arry[i].start()
		yield(arry[i], "tween_completed")
		arry[i].interpolate_property(spawn, "position", spawn.position, spawn.position + Vector2(rand1.x, -(rand1.y)), 1.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
		arry[i].interpolate_property(sp, "rotation_degrees", 1440, 2880, 1.0,  Tween.TRANS_LINEAR, Tween.EASE_IN)
		arry[i].start()
		yield(arry[i], "tween_completed")
		spawn.is_active = true

func fade_in(stream_player):
	stream_player.play()
	tween_out.interpolate_property(stream_player, "volume_db", -80, vol, 4.9, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	tween_out.start()

func _on_BossBuddySpawn_tween_completed(object: Object, key: NodePath) -> void:
	#print_debug(String(OS.get_ticks_msec()) + " Object:" + object.name, " Key: " + key)
	pass

func _on_BossBuddySpawn_tween_all_completed() -> void:
	#print_debug(String(OS.get_ticks_msec()) + " All Completed Signal")
	pass


func _on_BlockSpawner_timeout() -> void:
	swap = not swap
	$TileMap2.set_collision_layer_bit(3, swap)
	$TileMap2.visible = swap
	$BlockSpawner.start()


func _on_Boss2_dead() -> void:
	$BlockSpawner.stop()
	$TileMap2.set_collision_layer_bit(3, false)
	$TileMap2.visible = false
	$Portal2D.visible = true
	$Portal2D.position.y = 850


func _on_Boss2_hit(times_hit) -> void:
	$Shockwave/ShockAnimation.play("shockwave")
