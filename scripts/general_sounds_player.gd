extends AudioStreamPlayer2D

@export var light_dash: AudioStream
@export var medium_dash: AudioStream
@export var heavy_dash: AudioStream
@export var backdash: AudioStream
@export var parry: AudioStream
@export var whiff_parry: AudioStream
@export var block: AudioStream

@onready var _base_vol = volume_db
@onready var _base_pitch = pitch_scale

func play_dash(strength: float) -> void:
	pitch_scale = _base_pitch
	volume_db = _base_vol
	if strength < .2:
		stream = light_dash
	elif strength < 0.4:
		stream = medium_dash
	elif strength < 0.7:
		volume_db = 2.0
		stream = heavy_dash
	else:
		volume_db = 4.0
		pitch_scale = 0.9
		stream = heavy_dash
	play()


func play_backdash() -> void:
	volume_db = _base_vol
	pitch_scale = _base_pitch
	stream = backdash
	play()


func play_whiff() -> void:
	volume_db = _base_vol
	pitch_scale = _base_pitch
	stream = whiff_parry
	play()


func play_parry() -> void:
	volume_db = 8
	pitch_scale = 1.5
	stream = parry
	play()


func play_block() -> void:
	volume_db = _base_vol
	pitch_scale = _base_pitch
	stream = block
	play()
