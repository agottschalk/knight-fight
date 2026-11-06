class_name HitState
extends BasePlayerState

func enter() -> void:
	state_name = "P%s Hit" % player.player_num
	anim.play(&"Hit")
	anim.modulate = Color(1.0, 0.3, 0.3)
	player.play_hit_sound()
	player.request_hitstop(0.35, 4)
	player.x_vel = -70
	player.y_vel = -100
	player.collider.set_deferred(&"disabled", true)

func leave() -> void:
	player.x_vel = 0
	player.y_vel = 0
	anim.modulate = Color(1.0, 1.0, 1.0)
	player.collider.set_deferred(&"disabled", false)

func get_hit(_body: Node2D) -> void:
	pass
