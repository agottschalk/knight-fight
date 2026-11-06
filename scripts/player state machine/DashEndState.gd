class_name DashEndState
extends BasePlayerState

var recovery_time
var time_remaining

func enter():
	anim.play(&"Dash End")
	recovery_time = player.charge_time * player.RECOVERY_RATIO
	time_remaining = recovery_time
	player.x_vel /= 2

func physics_update(delta: float) -> void:
	time_remaining -= delta
	if time_remaining != 0:
		player.x_vel = move_toward(
			player.x_vel, 0, player.DASH_SPEED * delta / (2 * recovery_time))

func get_hit(other: Node2D) -> void:
	player.show_x()
	super(other)

func transition() -> void:
	if time_remaining <= 0:
		player.change_state(&"Idle")
