@tool
class_name SpawnerComponent extends Component

#region Export Variables
@export var scene : PackedScene :
	set(value):
		scene = value
		update_configuration_warnings()
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
