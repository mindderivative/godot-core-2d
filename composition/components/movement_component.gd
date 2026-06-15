@tool
class_name MovementComponent extends Component

#region Export Variables
@export var speed : Curve = Curve.new()
@export var max_speed : float = 300.0
@export var acceleration : float = 10.0
@export var stop_distance : float = 100.0
#endregion

#region Variables
var _parent : CharacterBody2D
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
	if target:
		
		# Calculate the distance to the target
		var distance : float = _parent.global_position.distance_to(target.global_position)
		
		# Rotate to look at the target
		_parent.look_at(target.global_position)
		
		# get the direction to target
		var direction : Vector2 = (target.global_position - _parent.global_position).normalized()
		
		# Sample curve for variable speeds
		var curve_sample = speed.sample(clamp((distance / 500.0), 0.0, 1.0))
		
		# Calculate final speed
		var current_speed = max_speed * curve_sample
		
		# Set the velocity
		_parent.velocity = _parent.velocity.lerp(direction * current_speed, acceleration * delta)
		
		# Stop if to close to target
		if distance < stop_distance:
			_parent.velocity = Vector2.ZERO
		
		# initiate the movement toward the target
		_parent.move_and_slide()
			

func _unhandled_input_component(event: InputEvent) -> void:
	pass

func _set_target() -> void:
	if not parent:
		print("MovementComponent: No parent node assigned!")
		return
	
	if not parent is CharacterBody2D:
		print("MovementComponent: The parent node needs to be a CharacterBody2D for this component to work.")
		return
	
	_parent = parent
#endregion

#region Component Functions

#endregion
