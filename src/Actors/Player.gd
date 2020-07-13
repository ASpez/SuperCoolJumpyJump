extends Actor


onready var snd_player: AudioStreamPlayer2D = $PlayerDeathSound
onready var jmp_snd_player: AudioStreamPlayer2D = $JumpSound
onready var lost_shield_snd_player: AudioStreamPlayer2D = $LostShieldSound
onready var player_died_anim: AnimationPlayer = $PlayerDied

export var stomp_impulse: = 1500.0

var is_dying: bool = false
var has_shield: bool = false
var is_teleporting = false


func _ready() -> void:
	if PlayerData.option_enable_shields:
		$shield.visible = true
		has_shield = true
	else:
		$shield.visible = false
		has_shield = false


func _on_EnemyDetector_area_entered(_area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	spawn_power_up()


func _on_EnemyDetector_body_entered(_body: Node) -> void:
	if PlayerData.option_god_mode:
		return
		
	if $HitTimer.is_stopped() == false:
		return
	if is_dying == false and is_teleporting == false and has_shield == false:
		is_dying = true
		player_died_anim.play("Zoom")
		snd_player.play()
		yield(snd_player,"finished")
		yield(player_died_anim, "animation_finished")
		die()
	
	if has_shield == true and PlayerData.buff_double_shield == false:
		$shield.visible = false
		lost_shield_snd_player.play()
		$HitTimer.start()
		#yield(get_tree().create_timer(1), "timeout")
		yield($HitTimer,"timeout")
		has_shield = false
		self.visible = true
		
	if PlayerData.buff_double_shield:
		lost_shield_snd_player.play()
		PlayerData.buff_double_shield = false
		PlayerData.score -= 100


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


func get_direction() -> Vector2:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jmp_snd_player.play()
		
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
	if PlayerData.deaths < 99:
		PlayerData.deaths += 1
	reset_buffs()
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
	else:
		$shield.modulate = Color("#ffffff")


func spawn_power_up() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randi_range(0, 100)
	var node: Node
	
	if rand < 95:
		match rng.randi_range(0, 2):
			0:
				if PlayerData.can_get_speed_boost:
					PlayerData.can_get_speed_boost = false
					node = get_node("../SpeedBoost")
					yield(get_tree().create_timer(.75), "timeout")
					node.position = self.position + Vector2(50.0, -300.0)
					node.visible = true
			1:
				if PlayerData.can_get_jump_boost:
					PlayerData.can_get_jump_boost = false
					node = get_node("../JumpBoost")
					yield(get_tree().create_timer(.75), "timeout")
					node.position = self.position + Vector2(50.0, -300.0)
					node.visible = true
			2:
				if PlayerData.can_get_shield_boost:
					PlayerData.can_get_shield_boost = false
					node = get_node("../ShieldBoost")
					yield(get_tree().create_timer(.75), "timeout")
					node.position = self.position + Vector2(50.0, -300.0)
					node.visible = true

	
	
