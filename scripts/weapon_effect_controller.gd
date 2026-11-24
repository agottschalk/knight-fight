extends Node2D

@onready var _particles := $Particles

var palette_number: int:
	get:
		return _palette_number as int
	set(value):
		_palette_number = value as float

var _palette_number: float

func activate() -> void:
	# palette numbers start at 1, but indecies start at 0
	_particles.set_instance_shader_parameter("palette_index", _palette_number - 1.0)
	_particles.emitting = true


func deactivate() -> void:
	_particles.emitting = false
