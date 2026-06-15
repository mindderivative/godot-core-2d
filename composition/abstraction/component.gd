@tool
## Base abstract class for all components.
##
## Components are nodes that calculate and perform a function. A [Data] resource must be inherited from for
## each component. Inherit from [Data] and create a specific resource for the component.
@abstract class_name Component extends Node

#region Export Variables
## If [code]true[/code] the component process and physics process are able to run as normal.
@export var enabled : bool = true
## The parent node of this component. Uses [member Object.get_parent()].
@export var parent : Node = null
## The target node of this component. Most of the time this is the [member Component.parent] node.
@export var target : Node = null
#endregion

#region Abstract functions
## Initialization runs before the component enters the tree or any child nodes are created.
@abstract func _init_component() -> void
## Ready runs after the component enters the tree and all child nodes are loaded into the tree.
@abstract func _ready_component() -> void
## Process runs on each idle frame, and after physics ticks have been processed.
@abstract func _process_component(delta: float) -> void
## Physics Process runs every physics tick.
@abstract func _physics_process_component(delta: float) -> void
## Called when an InputEvent hasn't been consumed by [member Node._input()] or any GUI Control item.
@abstract func _unhandled_input_component(event: InputEvent) -> void
#endregion

#region Initialization and Processing
func _init() -> void:
	_init_component()

func _ready() -> void:
	set_component_parent()
	_ready_component()

func _process(delta: float) -> void:
	if not enabled:
		return
	_process_component(delta)

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	_physics_process_component(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	_unhandled_input_component(event)
#endregion

#region Functions
## Sets the [member Component.parent] to the parent node if not [code]null[/code].
## [br][br]
## Called before [member _ready_component()].
func set_component_parent() -> void:
	if not self.get_parent():
		return
	else:
		parent = self.get_parent()
#endregion
