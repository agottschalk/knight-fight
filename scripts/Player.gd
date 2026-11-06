# holds signals and properties of player scene
# acts as a central place for internal components to interact, as well as 
# a bridge for external entities to interact with the player's components

class_name Player
extends CharacterBody2D

#region Properties and Constants

@export var WALK_SPEED := 30
@export var DASH_SPEED := 350
@export var BACKDASH_SPEED := 250
const BACKDASH_TIME := 0.3
const BACKDASH_ENDLAG := 0.1
const CHARGE_RATIO := 0.25
const RECOVERY_RATIO: float = 2.0 / 3
const MAX_CHARGE: float = 1.0	# seconds of charge time


var charge_time : float
var attack_priority : float
var anim_finished : bool	# states that use this should reset the flag
							# in thier 'enter' functions
var direction: int:
	get:
		if anim.flip_h:
			return -1
		return 1
var x_vel:
	get:
		return velocity.x * direction
	set(value):
		velocity.x = value * direction
var y_vel:
	get:
		return velocity.y
	set(value):
		velocity.y = value
var current_state:
	get:
		return _sm.current_state

@export var player_num : int
@export var sprites : SpriteFrames

signal hitstop_request()

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var collider : CollisionShape2D = $"Body Collider"
@onready var attackbox : Area2D = $Attackbox
@onready var hurtbox : Area2D = $Hurtbox
@onready var _icon : AnimatedSprite2D = $"Icon"
@onready var bar : ProgressBar = $"ProgressBar"
@onready var _hit_audio : AudioStreamPlayer2D = $"Hit Sounds Player"
@onready var _audio : AudioStreamPlayer2D = $"General Sounds Player"
var _sm : StateMachine

#endregion

#region Engine Functions

func _ready() -> void:
	bar.visible = false
	attackbox.set_deferred(&"disabled", true)
	if sprites:
		anim.sprite_frames = sprites
	else:
		push_warning("No sprites chosen for %s, default will be used." % self)
	if player_num == 0:
		push_warning("Player number not set for %s" % self)
	charge_time = 0
	attack_priority = -1
	
	_sm = StateMachine.new(self)


func _process(_delta: float) -> void:
	current_state.graphics_update()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if hurtbox.has_overlapping_areas():
		for area in hurtbox.get_overlapping_areas():
			_on_hurtbox_area_entered(area)
	current_state.physics_update(delta)
	
	move_and_slide()
	
	current_state.transition()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var other = area.get_parent()
	if other and other != self	\
		and &"attack_priority" in other	\
		and other.attack_priority > 0:
			current_state.get_hit(other)


func _on_animated_sprite_2d_animation_finished() -> void:
	anim_finished = true

#endregion

#region External Functions

func start() -> void:
	change_state(&"Idle")


func reset(reset_point: Transform2D) -> void:
	transform = reset_point
	velocity = Vector2(0, 0)
	change_state(&"Waiting")


func flip(default=true) -> void:
	anim.flip_h = default
	# _icon.flip_h = default


func change_state(to: String) -> void:
	_sm.change_state(to)


func show_interro() -> void:
	_icon.play(&"Interrobang")


func show_x() -> void:
	_icon.play(&"X")


func hide_icon() -> void:
	_icon.play(&"Blank")


func request_hitstop(seconds: float, shake: float) -> void:
	hitstop_request.emit(seconds, shake)


func play_hit_sound() -> void:
	_hit_audio.play()


func play_dash_sound() -> void:
	_audio.play_dash(charge_time)


func play_backdash_sound() -> void:
	_audio.play_backdash()


func play_whiff_sound() -> void:
	_audio.play_whiff()


func play_parry_sound() -> void:
	_audio.play_parry()


func play_block_sound() -> void:
	_audio.play_block()
#endregion
