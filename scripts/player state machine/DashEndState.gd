class_name DashEndState
extends BasePlayerState


func enter():
	anim.play(&"Dash End")
	player.anim_finished = false

func get_hit(other: Node2D) -> void:
	player.show_icon(&"X")
	super(other)

func transition() -> void:
	if player.anim_finished:
		player.change_state(&"Idle")
