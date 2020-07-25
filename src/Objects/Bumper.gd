extends "res://src/Actors/Actor.gd"


onready var shooting_sound: AudioStreamPlayer2D = $ShootingSound

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_BumperStompDetector_body_entered(body: Node) -> void:
	shooting_sound.play()
	$ShootingParticles.visible = true
	$ShootingParticles.emitting = true
