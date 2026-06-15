@tool
class_name RadarComponent extends Component

signal body_entered_radar(instanced_id : int)
signal body_exited_radar(instanced_id : int)

#region Export Variables
@export var radar_area2d : Area2D
@export var radar_array : Array[Node2D] = []
#endregion

#region Variables

#endregion

#region State Initialization
func _init_component() -> void:
	pass

func _ready_component() -> void:
	radar_area2d.body_entered.connect(_on_body_entered)
	radar_area2d.body_exited.connect(_on_body_exited)
	_set_target()

	#if target is Node2D:
		# target node functions

func _process_component(delta: float) -> void:
	pass

func _physics_process_component(delta: float) -> void:
	if radar_array.is_empty():
		return
	
	if target is Node2D:
		radar_array.sort_custom(sort_by_distance)

func _unhandled_input_component(event: InputEvent) -> void:
	pass

func _set_target() -> void:
	if not target and parent:
		target = parent
#endregion

#region Component Functions
func _on_body_entered(body : Node2D) -> void:
	if body:
		radar_array.append(body)
		body_entered_radar.emit(body.get_instance_id())
func _on_body_exited(body : Node2D) -> void:
	if body:
		radar_array.erase(body)
		body_exited_radar.emit(body.get_instance_id())

func sort_by_distance(a : Node2D, b : Node2D) -> bool:
	return a.global_position.distance_squared_to(target.global_position) < b.global_position.distance_squared_to(target.global_position)
#endregion
