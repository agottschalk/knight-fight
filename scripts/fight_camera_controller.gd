extends Camera2D

var player_1 : Node2D
var player_2 : Node2D
@export var zoom_ratio : float = 200.0
@export var max_zoom : float = 1.5
@export var min_zoom : float = 0.8

var _shake_intensity : float = 0
var _decay : float = 1


func _process(delta: float) -> void:
	center_on_fighters()
	_shake_screen()
	_shake_intensity -= delta * _decay


func center_on_fighters() -> void:
	var center = Vector2((player_1.position.x + player_2.position.x) / 2,
						position.y)
	position = center
	var distance = player_1.position.distance_to(player_2.position)
	if distance > 0:	# shouldn't happen, but prevents div by 0 error anyway
		var zoom_factor = clamp(zoom_ratio / distance, min_zoom, max_zoom)
		zoom = Vector2(zoom_factor, zoom_factor)


# requests screen to shake according to parameter
func screen_shake(intensity: float, seconds: float) -> void:
	if seconds > 0:
		_shake_intensity = intensity
		_decay = _shake_intensity / seconds


# internal method for creating screen shake
func _shake_screen() -> void:
	if _shake_intensity > 0:
		offset = Vector2(randf_range(-_shake_intensity, _shake_intensity), 
				randf_range(-_shake_intensity, _shake_intensity))
	else:
		offset = Vector2.ZERO
