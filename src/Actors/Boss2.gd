extends "res://src/Actors/Actor.gd"



export var score: int = 500
export var hit_points: int = 0

var times_hit = 0
var y_direction = 0.0
var is_dying: bool = false
var is_invicible: bool = false
var rng = RandomNumberGenerator.new()


onready var start_boss_fight = false
onready var snd_player: AudioStreamPlayer2D = $EnemyDeathSound

signal dead
signal hit(times_hit)
signal spawn(spawn_number, boss_position)


func _enter_tree():
	var shake_tween = Tween.new()
	shake_tween.name = "TweenShake"
	add_child(shake_tween)    
	shake_tween.connect("tween_completed", self, "on_tween_completed")

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

func set_start_boss_fight() -> void:
	if start_boss_fight == false:
		$BossTimer.start()

	start_boss_fight = true


func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	if is_invicible:
		return
	if $HitTimer.is_stopped() == false:
		return
	if hit_points > times_hit:
		$StompDetector.set_deferred("monitorable", false)
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(1, false)
		$StompDetector.set_collision_layer_bit(1, false)
		$HitTimer.start()
		times_hit += 1
		emit_signal("hit", times_hit)
		$BossHit.play()
		yield($HitTimer, "timeout")
		$StompDetector.set_deferred("monitorable", true)
		set_collision_mask_bit(0, true)
		set_collision_layer_bit(1, true)
		$StompDetector.set_collision_layer_bit(1, true)
		self.visible = true
	else:
		if is_dying == false:
			is_dying = true
			set_physics_process(false)
			set_collision_mask_bit(0, false)
			set_collision_layer_bit(1, false)
			$StompDetector.set_collision_layer_bit(1, false)
			emit_signal("dead")
			die()
	if times_hit == 4 or times_hit == 8:
		#boss_buddy_spawner((1*times_hit)/2)
		emit_signal("spawn", times_hit / 2, self.position)
		is_invicible = true
		self.scale += Vector2(.5, .5)

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if start_boss_fight:
		var slope_angle
		
		_velocity.y += gravity * delta
		if y_direction == -1:
			_velocity.y = (y_direction * speed.y)
		for i in get_slide_count():
			var normal = get_slide_collision(i).normal
			slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
		if is_on_wall() and slope_angle == 0:
			_velocity.x *= -1.0
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		
		if $HitTimer.is_stopped() == false:
			self.visible = not self.visible
			
		if not are_boss_buddies_alive():
			is_invicible = false


func die() -> void:
	if PlayerData.option_enable_particles:
		$Particles2D.visible = true
		$Particles2D.emitting = true
	
	PlayerData.score += self.score
	snd_player.play()
	yield(snd_player,"finished")
	yield(get_tree().create_timer(2), "timeout")
	$DeathAnimation.play("Death")
	yield(get_tree().create_timer(.55), "timeout")
	$BossTimer.stop()
	queue_free()


func boss_buddy_spawner(count: int) -> void:
	pass

func are_boss_buddies_alive() -> bool:
	var num = get_tree().get_nodes_in_group("BossBuddy")
	if num == null:
		return false
	if not num.empty():
		return true
	return false

func _on_BossTimer_timeout() -> void:
	if start_boss_fight:
		if $BossTimer.is_stopped():
			rng.randomize()
			if _velocity.x < 0:
				_velocity.x = -300 + (times_hit * -50)
			else:
				_velocity.x = 300 + (times_hit * 50)
			
			#if is_on_floor():
			#	y_direction = -1
			#	yield(get_tree().create_timer(.02), "timeout")
			#	y_direction = 0
			$BossTimer.start(rng.randf_range(.5, 5.0 - ((1.0+float(hit_points) / 2.0))))

