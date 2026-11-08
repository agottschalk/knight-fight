extends Node2D

@onready var _light := $PointLight2D
@onready var _up := $UpParticles
@onready var _down := $DownParticles

func activate() -> void:
	_up.emitting = true
	_down.emitting = true
	_light.enabled = true


func deactivate() -> void:
	_up.emitting = false
	_down.emitting = false
	_light.enabled = false
