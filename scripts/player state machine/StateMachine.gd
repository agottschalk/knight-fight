# Manages player's states and state transitions

class_name StateMachine
extends Node

var _player
var _states: Dictionary[String, BasePlayerState] = {}
var current_state: BasePlayerState:
	get:
		return _current_state
var _current_state: BasePlayerState:
	get:
		return _current_state
	set(value):
		if _current_state:
			_current_state.leave()
		_current_state = value
		_current_state.enter()


func _init(player: Player):
	_player = player
	_states[&"Waiting"] = WaitingState.new(player)
	_states[&"Idle"] = IdleState.new(player)
	_states[&"Windup"] = WindupState.new(player)
	_states[&"Dash"] = DashState.new(player)
	_states[&"DashEnd"] = DashEndState.new(player)
	_states[&"Backdash"] = BackdashState.new(player)
	_states[&"Guard"] = GuardState.new(player)
	_states[&"Hit"] = HitState.new(player)
	_current_state = _states[&"Waiting"]


func change_state(to: String) -> void:
	if _states.has(to):
		_current_state = _states[to]
	else:
		push_error("%s does not have state %s" % [_player, to])


func get_state_names() -> Array:
	return _states.keys()
