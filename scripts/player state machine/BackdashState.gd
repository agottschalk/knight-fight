class_name BackdashState
extends BasePlayerState

var time_remaining

func enter() -> void:
	state_name = "P%s Backdash" % player.player_num
	player.x_vel = -player.BACKDASH_SPEED
	time_remaining = player.BACKDASH_TIME + player.BACKDASH_ENDLAG
	player.play_backdash_sound()

func physics_update(delta: float) -> void:
	time_remaining -= delta
	player.x_vel = move_toward(player.x_vel, 0, 
			delta * player.BACKDASH_SPEED / player.BACKDASH_TIME)

func graphics_update() -> void:
	anim.play(&"Backdash")

func leave() -> void:
	player.x_vel = 0

func transition() -> void:
	if time_remaining < 0:
		player.change_state(&"Idle")
