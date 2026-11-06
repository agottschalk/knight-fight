class_name GuardState
extends BasePlayerState

var cancellable

func enter() -> void:
	cancellable = false
	player.anim_finished = false
	player.x_vel = 0
	player.play_whiff_sound()
	anim.play(&"Shield")

func get_hit(other: Node2D) -> void:
	if anim.frame == 0:	# to change the perfect parry Window, change the 
						# duration of the first frame in the animation player
		anim.modulate = Color(3,3,3)
		other.change_state(&"DashEnd")
		cancellable = true
		player.play_parry_sound()
		player.request_hitstop(0.5, 0)
	elif anim.frame < 4:
		player.x_vel = -player.DASH_SPEED * 5
		other.change_state(&"DashEnd")
		player.play_block_sound()
	else:
		player.show_interro()
		player.change_state(&"Hit")

func physics_update(_delta: float) -> void:
	player.x_vel = move_toward(
		player.x_vel, 0, abs(player.x_vel * 0.4))	# smaller multiplier for more pushback

func transition() -> void:
	if player.anim_finished:
		player.change_state(&"Idle")
	elif cancellable and Input.is_action_pressed("p%s_attack" % player.player_num):
		player.change_state(&"Windup")

func leave() -> void:
	anim.modulate = Color(1,1,1)
	player.x_vel = 0
