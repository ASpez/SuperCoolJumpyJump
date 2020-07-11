extends "res://src/Actors/Actor.gd"


onready var snd_player: AudioStreamPlayer2D = $EnemyDeathSound
export var score: = 100

var is_dying: bool = false
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	set_physics_process(false)
	#Things get a bit more challenging after level 3
	if PlayerData.level > 3:
		rng.randomize()
		speed.x += rng.randi_range(15, 50)
	_velocity.x = -speed.x
	
	
func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	if is_dying == false:
		is_dying = true
		#$enemy.visible = false
		$DeathAnimation.play("Death")
		set_physics_process(false)
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(1, false)
		$StompDetector.set_collision_layer_bit(1, false)
		die()
	
	
func _physics_process(delta: float) -> void:
	var slope_angle
	_velocity.y += gravity * delta
	for i in get_slide_count():
			var normal = get_slide_collision(i).normal
			slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
	if is_on_wall() and slope_angle == 0:
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y


func die() -> void:
	if PlayerData.option_enable_particles:
		$Particles2D.visible = true
		$Particles2D.emitting = true
	
	PlayerData.score += self.score
	snd_player.play()
	yield(snd_player,"finished")
	yield(get_tree().create_timer(.75), "timeout")
	queue_free()
