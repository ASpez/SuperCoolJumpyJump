extends Actor


onready var player_died_anim: AnimationPlayer = $PlayerDied
onready var powerup_snd: AudioStreamPlayer2D = $PowerUpSpawn
onready var jmp_snd_player: AudioStreamPlayer2D = $JumpSound
onready var snd_player: AudioStreamPlayer2D = $PlayerDeathSound
onready var lost_shield_snd_player: AudioStreamPlayer2D = $LostShieldSound

onready var bus_effects = AudioServer.get_bus_index("Effects")
onready var bus_echo = AudioServer.get_bus_index("Echo")

export (float) var stomp_impulse: = 1500.0


var is_dying: bool = false
var is_teleporting = false
var has_shield: bool = false

var effect_bus_to_use = "Effects"

# Increases with each level
var powerup_bonus_chance = 3


func _ready() -> void:
	if PlayerData.level == 6:
		effect_bus_to_use = "Echo"
	powerup_bonus_chance += (PlayerData.level * 2)
	if PlayerData.option_enable_shields:
		$shield.visible = true
		has_shield = true
	else:
		$shield.visible = false
		has_shield = false


func _on_EnemyDetector_area_entered(_area: Area2D) -> void:
	if _area.name == "BumperStompDetector":
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse + 800)
	else:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

	#$Camera2D/SceenShake.start(0.2, 15, 5, 0)

func _on_EnemyDetector_body_entered(_body: Node) -> void:
	if _body.is_in_group("bumpers"):
		return
	if PlayerData.option_god_mode:
		return
	if is_teleporting:
		return
	if $HitTimer.is_stopped() == false:
		return
	if is_dying == false and has_shield == false:
		is_dying = true
		
		die()
	
	if has_shield == true:
		$Camera2D/SceenShake.start(0.4, 15, 25, 1)
		$HitTimer.start()
		if PlayerData.buff_double_shield:
			lost_shield_snd_player.play()
			#play_effect(lost_shield_snd_player, effect_bus_to_use, false)
			PlayerData.buff_double_shield = false
			PlayerData.can_get_shield_boost = true
			PlayerData.score -= 100
			yield($HitTimer,"timeout")
			self.visible = true
			return

		$shield.visible = false
		lost_shield_snd_player.play()
		#play_effect(lost_shield_snd_player, effect_bus_to_use, false)

		yield($HitTimer,"timeout")
		has_shield = false
		self.visible = true


func _physics_process(_delta: float) -> void:
	check_buffs()
	if is_teleporting and PlayerData.option_enable_particles:
		$Particles2D.emitting = true
	if is_teleporting == false and is_dying == false:
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction: = get_direction()
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if $HitTimer.is_stopped() == false:
		self.visible = not self.visible


func _process(delta: float) -> void:
	match PlayerData.level:
		2, 5:
			if self.position.y > 960:
				effect_bus_to_use = "Echo"
			if self.position.y < 960:
				effect_bus_to_use = "Effects"
				
	#if PlayerData.level == 5 and self.position.y > 960:
	#	effect_bus_to_use = "Echo"
	#if PlayerData.level == 5 and self.position.y < 960:
	#	effect_bus_to_use = "Effects"
		
func get_direction() -> Vector2:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#jmp_snd_player.play()
		play_effect(jmp_snd_player, effect_bus_to_use, false)
		
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
	)
	
	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity
	
	
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out


func die() -> void:
	player_died_anim.play("Zoom")
	#play_effect(snd_player, effect_bus_to_use, true)
	snd_player.play()
	yield(snd_player, "finished")
	yield(player_died_anim, "animation_finished")
	
	reset_buffs()
	
	if PlayerData.deaths < 99:
		PlayerData.deaths += 1

	#queue_free()


func reset_buffs()-> void:
	PlayerData.can_get_jump_boost = true
	PlayerData.can_get_shield_boost = true
	PlayerData.can_get_speed_boost = true
	PlayerData.buff_double_shield = false
	PlayerData.buff_speed_boost = false
	PlayerData.buff_jump_boost = false
	
func check_buffs() -> void:
	if PlayerData.buff_jump_boost:
		gravity = 3700
	else:
		gravity = 4000
		
	if PlayerData.buff_speed_boost:
		speed.x = 600
	else:
		speed.x = 500
		
	if PlayerData.buff_double_shield:
		$shield.modulate = Color("#2cff00")
		$shield.visible = true
		has_shield = true
	else:
		$shield.modulate = Color("#ffffff")


func spawn_power_up(enemy_position: Vector2) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randi_range(0, 100)
	var node: Node
	
	PlayerData.total_hits += 1
	if rand < powerup_bonus_chance:
		PlayerData.total_crits += 1
		match rng.randi_range(0, 2):
			0:
				if PlayerData.can_get_speed_boost:
					node = get_node("../SpeedBoost")
					if node:
						#powerup_snd.play()
						play_effect(powerup_snd, effect_bus_to_use, false)
						#node.position = self.position + Vector2(0, -10)
						node.position = enemy_position + Vector2(0, -50)
						node.visible = true
						node.get_node("AnimationPlayer").play("Appear")
						yield(get_tree().create_timer(1), "timeout")
						node.get_node("AnimationPlayer").play("bouncing")

			1:
				if PlayerData.can_get_jump_boost:
					node = get_node("../JumpBoost")
					if node:
						#powerup_snd.play()
						play_effect(powerup_snd, effect_bus_to_use, false)
						#node.position = self.position + Vector2(0, -10)
						node.position = enemy_position + Vector2(0, -50)
						node.visible = true
						node.get_node("AnimationPlayer").play("Appear")
						yield(get_tree().create_timer(1), "timeout")
						node.get_node("AnimationPlayer").play("bouncing")

			2:
				if PlayerData.can_get_shield_boost:
					node = get_node("../ShieldBoost")
					if node:
						#powerup_snd.play()
						play_effect(powerup_snd, effect_bus_to_use, false)
						#node.position = self.position + Vector2(0, -10)
						node.position = enemy_position + Vector2(0, -50)
						node.visible = true
						node.get_node("AnimationPlayer").play("Appear")
						yield(get_tree().create_timer(1), "timeout")
						node.get_node("AnimationPlayer").play("bouncing")

func play_effect(stream: AudioStreamPlayer2D, effect_bus: String, should_yield: bool) -> void:
	stream.bus = effect_bus
	stream.play()
	if should_yield:
		yield(stream, "finished")

func freeze() -> void:
	set_physics_process(not is_physics_processing())

func _on_Boss2_hit(times_hit) -> void:
	var duration = min(0.2 * times_hit, 1.5)
	var frequency = 15 + (times_hit * 1.75)
	var amplitude = min(20 + (times_hit * 2), 32)
	var priority = 3
	var string = "times hit: " + String(times_hit) + " duration: " + String(duration)
	string += " frequency: " + String(frequency) + " amplitude: " + String(amplitude)
	print_debug(string)
	$Camera2D/SceenShake.start(duration, frequency, amplitude, priority)

func level_8_boss_drop_enter() -> void:
	pass





