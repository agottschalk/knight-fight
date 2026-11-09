extends Node2D

@export var player_1 : Node2D
@export var player_2 : Node2D
@export var kill_plane := 200
@export var text_display_sec := 1.0

@onready var p1_start = $"P1 Start"
@onready var p2_start = $"P2 Start"

var p1_score := 0
var p2_score := 0

@onready var fight_text = $"Fight Text"
@onready var camera = $"Camera2D"


func _ready() -> void:
	if player_1:
		p1_start.transform = player_1.transform
		player_1.hitstop_request.connect(_hitstop)
		camera.player_1 = player_1
	else:
		push_warning("Player 1 not assigned in scene manager")
	
	if player_2:
		p2_start.transform = player_2.transform
		player_2.hitstop_request.connect(_hitstop)
		camera.player_2 = player_2
	else:
		push_warning("Player 2 not assigned in scene manager")
	
	fight_text.text = ""
	reset()


func _process(_delta: float) -> void:
	# placeholder for testing
	if Input.is_action_just_pressed("ui_focus_next"):
		reset()


func _physics_process(_delta: float) -> void:
	if player_1.attack_priority > 0 and \
			player_1.attack_priority >= player_2.attack_priority:
		player_1.activate_weapon_effect()
		player_2.deactivate_weapon_effect()
	if player_2.attack_priority > 0 and \
			player_2.attack_priority >= player_1.attack_priority:
		player_2.activate_weapon_effect()
		player_1.deactivate_weapon_effect()
	
	if player_1.position.y > kill_plane or player_2.position.y > kill_plane:
		reset()


func reset() -> void:
	player_1.reset(p1_start.transform)
	player_2.reset(p2_start.transform)
	if player_1.position.x > player_2.position.x:
		player_1.flip()
		player_2.flip(false)
	else:
		player_2.flip()
		player_1.flip(false)
	camera.center_on_fighters()
	camera.reset_smoothing()
	fight_text.text = ""
	await get_tree().create_timer(0.3).timeout
	fight_text.text = "%s - %s" % [p1_score, p2_score]
	await get_tree().create_timer(text_display_sec * 1.5).timeout
	fight_text.text = "Ready?"
	await get_tree().create_timer(text_display_sec).timeout
	fight_text.text = "Fight!"
	await get_tree().create_timer(text_display_sec).timeout
	fight_text.text = ""
	player_1.start()
	player_2.start()


func _hitstop(seconds: float, shake: float):
	camera.screen_shake(shake, seconds)
	Engine.time_scale = 0.02
	await get_tree().create_timer(seconds, true, true, true).timeout
	Engine.time_scale = 1.0


func _on_p1_kod():
	p2_score += 1


func _on_p2_kod():
	p1_score += 1
