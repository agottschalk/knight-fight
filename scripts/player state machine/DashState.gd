class_name DashState
extends BasePlayerState

var active_frames	# measured in seconds, despite name

func enter() -> void:
	state_name = "P%s Dash" % player.player_num
	player.charge_time = clamp(player.charge_time, 0, player.MAX_CHARGE)
	player.attack_priority = 1
	active_frames = player.charge_time * player.CHARGE_RATIO
	player.x_vel = player.DASH_SPEED
	player.attackbox.set_deferred(&"disabled", false)
	player.play_dash_sound()
	anim.play(&"Dash")

func get_hit(other: Node2D) -> void:
	if &"attack_priority" in other:
		if other.attack_priority > 0 and player.attack_priority <= other.attack_priority:
			player.show_x()
			player.change_state(&"Hit")

func physics_update(delta: float) -> void:
	active_frames -= delta
	player.attack_priority += delta

func graphics_update() -> void:
	anim.frame = 0 if active_frames > 0.1 else 1

func transition() -> void:
	if active_frames < 0:
		player.hide_icon()	# only hide if transitioning naturally, leave icon if hit
		player.change_state(&"DashEnd")

func leave() -> void:
	player.set_deferred(&"attack_priority", -1)
	player.attackbox.set_deferred(&"disabled", true)
