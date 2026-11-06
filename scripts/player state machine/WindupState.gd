class_name WindupState
extends BasePlayerState

func enter():
	player.x_vel = 0
	player.charge_time = 0
	player.bar.value = 0
	player.bar.visible = true
	anim.play(&"Dash Windup")

func physics_update(delta: float) -> void:
	player.charge_time += delta

func graphics_update() -> void:
	player.bar.value = player.charge_time

func get_hit(other: Node2D) -> void:
	player.show_interro()
	super(other)

func transition():
	if Input.is_action_just_released("p%s_attack" % player.player_num):
		player.change_state(&"Dash")

func leave() -> void:
	player.bar.visible = false
