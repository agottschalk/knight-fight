# holds signals and properties of player scene
# acts as a central place for internal components to interact, as well as 
# a bridge for external entities to interact with the player's components

class_name Player
extends CharacterBody2D

#region Properties and Constants

# Transform basis X components for left and right facing objects
# For these to work properly, all nodes using them must have an X scale of 1
const LEFT_FACING_X := Vector2(-1, 0)
const RIGHT_FACING_X := Vector2(1, 0)

const WALK_SPEED := 18
const MAX_DASH_SPEED := 150
const MIN_DASH_SPEED := 0.5	# as a fraction of maximum dash speed
const BACKDASH_SPEED := 150
const DRAG := 450
const BACKDASH_TIME := 0.3
const BACKDASH_ENDLAG := 0.1
const CHARGE_RATIO := 0.5
const RECOVERY_RATIO: float = 2.0 / 3
const MAX_CHARGE: float = 0.75	# seconds of charge time


var charge_time : float
var attack_priority : float
var anim_finished : bool	# states that use this should reset the flag
							# in thier 'enter' functions
var direction: float:
	get:
		return scale.y	# godot converts negative x scale into negative y and 180 deg rotation
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
@export var weapon_effect: PackedScene

signal hitstop_request()
signal player_kod()	# emitted by Hit state

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var collider : CollisionShape2D = $"Body Collider"
@onready var attackbox : Area2D = $Attackbox
@onready var hurtbox : Area2D = $Hurtbox
@onready var _icon : AnimatedSprite2D = $"Icon"
@onready var bar : ProgressBar = $"ProgressBar"
@onready var _hit_audio : AudioStreamPlayer2D = $"Hit Sounds Player"
@onready var _audio : AudioStreamPlayer2D = $"General Sounds Player"
var _weapon_effect
var _sm : StateMachine

#endregion

#region Engine Functions

func _ready() -> void:
	bar.visible = false
	attackbox.set_deferred(&"disabled", true)
	
	if weapon_effect:
		_weapon_effect = weapon_effect.instantiate()
		add_child(_weapon_effect)
		_weapon_effect.palette_number = player_num
	else:
		push_error("%s has no weapon effect assigned" % self)
	
	match player_num:
		1:
			anim.set_instance_shader_parameter("new_tassle",ColorPalettes.P1[0])
			anim.set_instance_shader_parameter("new_shadow",ColorPalettes.P1[1])
		2:
			anim.set_instance_shader_parameter("new_tassle",ColorPalettes.P2[0])
			anim.set_instance_shader_parameter("new_shadow",ColorPalettes.P2[1])
		_:
			push_warning("Player number not set for %s" % self)
	
	charge_time = 0
	attack_priority = -1
	
	_sm = StateMachine.new(self)


func _process(_delta: float) -> void:
	current_state.graphics_update()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		x_vel = move_toward(x_vel, 0, DRAG * delta)
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


func flip(face_left=true) -> void:
	# flipping the icon when flipping player unflips the icon
	if face_left:
		transform.x = LEFT_FACING_X
		_icon.transform.x = LEFT_FACING_X
	else:
		transform.x = RIGHT_FACING_X
		_icon.transform.x = RIGHT_FACING_X


func change_state(to: String) -> void:
	_sm.change_state(to)


func show_icon(icon_name: String) -> void:
	_icon.play(icon_name)


func hide_icon() -> void:
	_icon.play(&"Blank")


func activate_weapon_effect() -> void:
	_weapon_effect.activate()


func deactivate_weapon_effect() -> void:
	_weapon_effect.deactivate()


func request_hitstop(seconds: float, shake: float) -> void:
	hitstop_request.emit(seconds, shake)


func play_sound(sound_name: String) -> void:
	match sound_name:
		&"Hit":
			_hit_audio.play()
		&"Dash":
			_audio.play_dash(charge_time / MAX_CHARGE)
		&"Backdash":
			_audio.play_backdash()
		&"Whiff":
			_audio.play_whiff()
		&"Parry":
			_audio.play_parry()
		&"Block":
			_audio.play_block()
		&"Charge":
			_audio.play_charge()
		_:
			push_error("No sound with name %s" % sound_name)

#endregion
