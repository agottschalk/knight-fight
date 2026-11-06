@abstract 
class_name BasePlayerState

var state_machine : StateMachine
var player : Player
var anim : AnimatedSprite2D
var state_name : String = &"Unnamed State"

func _init(attached_player: Player, attached_state_machine: StateMachine = null):
	self.player = attached_player
	self.state_machine = attached_state_machine
	self.anim = player.anim

func enter() -> void:
	pass

func leave() -> void:
	pass

func get_hit(_other: Node2D) -> void:
	player.change_state(&"Hit")

func physics_update(_delta: float) -> void:
	pass

func graphics_update() -> void:
	pass

# checks if the player should transition to the next state
# do not do cleanup here, that belongs in leave()
func transition() -> void:
	pass
