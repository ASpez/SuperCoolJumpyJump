extends "res://src/Actors/Actor.gd"



onready var snd_player: AudioStreamPlayer2D = $EnemyDeathSound


var is_dying = false
var is_active = false

func _ready() -> void:
	#set_physics_process(false)
	_velocity.x = -speed.x

func _on_StompDetector_body_entered(body: Node) -> void:
	if is_active == false:
		return
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return

	if is_dying == false:
		is_dying = true
		#$enemy.visible = false
		$Animation.play("Death")
		set_physics_process(false)
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(1, false)
		$StompDetector.set_collision_layer_bit(1, false)
		die()

func _physics_process(delta: float) -> void:
	if is_active == false:
		return
	var slope_angle
	_velocity.y += gravity * delta
	for i in get_slide_count():
			var normal = get_slide_collision(i).normal
			slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
	if is_on_wall() and slope_angle == 0:
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die() -> void:
	snd_player.play()
	yield(snd_player,"finished")
	queue_free()


func _on_Animation_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		is_active = true
		_velocity.x = -speed.x
