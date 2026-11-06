class_name IdleState 
extends BasePlayerState

var joystick	#last reading of joystick left axis, used by multiple methods

func enter() -> void:
	joystick = 0.0
	state_name = "P%s Base" % player.player_num
	player.hide_icon()

func physics_update(_delta: float) -> void:
	# since player vel is relative to facing direction, but joysticks are
	# absolute, have to multiply by player direction for it to work right
	joystick = Input.get_axis("p%s_left" % player.player_num, 
			"p%s_right" % player.player_num) * player.direction
	if joystick:
		player.x_vel = joystick * player.WALK_SPEED
	else:
		player.x_vel = move_toward(player.x_vel, 0, player.WALK_SPEED)

func graphics_update() -> void:
	if joystick > 0:
		anim.play(&"Walk")
	elif joystick < 0:
		anim.play(&"Backwalk")
	else:
		anim.play(&"Idle")

func transition() -> void:
	if Input.is_action_pressed("p%s_attack" % player.player_num):
		if joystick < 0:
			player.change_state(&"Backdash")
		else:
			player.change_state(&"Windup")
	elif Input.is_action_pressed("p%s_guard" % player.player_num):
		player.change_state(&"Guard")

func leave() -> void:
	player.x_vel = 0
	player.y_vel = 0
