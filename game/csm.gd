class_name CallableStateMachine

var state_dictionary = {}
var current_state: String

signal state_changed(from, to)

func add_states(
	normal_state_callable: Callable,
	enter_state_callable: Callable = Callable(),
	leave_state_callable: Callable = Callable()
):
	state_dictionary[normal_state_callable.get_method()] = {
		"normal": normal_state_callable,
		"enter": enter_state_callable,
		"leave": leave_state_callable
	}


func set_initial_state(state_callable: Callable):
	var state_name = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state(state_name)
	else:
		push_warning("No state with name " + state_name)


func update():
	if current_state != null:
		(state_dictionary[current_state].normal as Callable).call()


func change_state(state_callable: Callable):
	var state_name = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state with name " + state_name)


func _set_state(state_name: String):
	if current_state:
		var leave_callable = state_dictionary[current_state].leave as Callable
		if !leave_callable.is_null():
			leave_callable.call()
	
	state_changed.emit(current_state, state_name)
	current_state = state_name
	
	var enter_callable = state_dictionary[current_state].enter as Callable
	if !enter_callable.is_null():
		enter_callable.call()
