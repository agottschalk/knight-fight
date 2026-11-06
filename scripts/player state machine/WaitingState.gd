class_name WaitingState 
extends BasePlayerState

func graphics_update() -> void:
	anim.play(&"Idle")
	player.hide_icon()
