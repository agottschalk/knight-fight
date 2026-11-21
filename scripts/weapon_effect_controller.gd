extends Node2D

@onready var _particles := $Particles
@onready var _flame := $AnimatedSprite2D
@onready var _light := $PointLight2D


func _ready() -> void:
	deactivate()

func activate() -> void:
	_particles.emitting = true
	_light.enabled = true
	_flame.visible = true
	_flame.play(&"default")


func deactivate() -> void:
	_particles.emitting = false
	_light.enabled = false
	_flame.visible = false
