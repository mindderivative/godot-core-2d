# meta-name: Component
# meta-description: Template for creating new components
@tool
class_name _CLASS_ extends Component

#region Export Variables

#endregion

#region Variables

#endregion

#region State Initialization
func _init_component() -> void:
	pass

func _ready_component() -> void:
	_set_target()

	#if target is Node2D:
		# target node functions

func _process_component(delta: float) -> void:
	pass

func _physics_process_component(delta: float) -> void:
	pass

func _unhandled_input_component(event: InputEvent) -> void:
	pass

func _set_target() -> void:
	if not target and parent:
		target = parent
#endregion

#region Component Functions

#endregion
