extends Node2D

@onready var _particles := $Particles

func activate() -> void:
	_particles.emitting = true


func deactivate() -> void:
	_particles.emitting = false
