## The PanAndZoomComponent provides a [Camera2D] the pan and zoom functionality.
##
## A [PanAndZoomData] resource is required for this component to work.
class_name PanAndZoomComponent extends Component

#region Export Variables
## A [PanAndZoomData] resource is required for this component.
@export var data : PanAndZoomData
#endregion

#region Variables
var zoom_goal : Vector2
var position_goal : Vector2
var fallback_mouse_pan : bool
var fallback_mouse_zoom_in : bool
var fallback_mouse_zoom_out : bool
var last_mouse : Vector2
var zoom_mouse : Vector2
var damped_pan : Array[Vector2]
var damped_zoom : Array[Vector2]
var resolution : Vector2
#endregion

#region State Initialization
func _init_component() -> void:
	pass

func _ready_component() -> void:
	SignalBus.PanZoom.can_pan_and_zoom.connect(_on_can_pan_and_zoom)
	data.panSmoothing = data.panSmoothing
	data.zoomSmoothing = data.zoomSmoothing
	
	var actions : Array[StringName] = InputMap.get_actions()
	var always = data.useFallbackButtons == "Always"
	var never = data.useFallbackButtons == "Never"
	fallback_mouse_pan = not never and (always or (data.panAction not in actions))
	fallback_mouse_zoom_in = not never and (always or (data.zoomInAction not in actions))
	fallback_mouse_zoom_out = not never and (always or (data.zoomOutAction not in actions))
	
	if not always and (fallback_mouse_pan or fallback_mouse_zoom_in or fallback_mouse_zoom_out):
		prints("PanAndZoomComponent: Mouse Fallbacks for Actions in effect!",
			data.panAction + " = " + str(fallback_mouse_pan),
			data.zoomInAction + " = " + str(fallback_mouse_zoom_in),
			data.zoomOutAction + " = " + str(fallback_mouse_zoom_out))
		printt("PanAndZoomComponent: TIP - set up all three of the following InputActions:", data.panAction, data.zoomInAction, data.zoomOutAction)
	
	_set_target()
	
	if target is Camera2D:
		zoom_goal = target.zoom
		position_goal = target.position
		damped_pan = [target.position, Vector2.ZERO]
		damped_zoom = [target.zoom, Vector2.ZERO]
		resolution = get_viewport().get_visible_rect().size
		print(resolution)
	else:
		print("PanAndZoomComponent: Parent or Target property is not set to Camera2D.")

func _process_component(delta: float) -> void:
	if !enabled:
		return
	_smooth_damp(damped_zoom, zoom_goal, data.zoomSmoothing, delta)

	if target is Camera2D:
		var mouse_pre_zoom : Vector2 = target.to_local(get_viewport().get_screen_transform().affine_inverse().basis_xform(zoom_mouse))
		target.zoom = damped_zoom[0]
		var mouse_post_zoom : Vector2 = target.to_local(get_viewport().get_screen_transform().affine_inverse().basis_xform(zoom_mouse))
		
		var zoom_position_offset : Vector2 = (mouse_pre_zoom - mouse_post_zoom) if data.zoomToCursor else Vector2.ZERO
		
		position_goal += zoom_position_offset
		damped_pan[0] += zoom_position_offset
		
		if data.limits_enabled:
			position_goal = position_goal.clamp(Vector2(data.left + (resolution.x * 0.5), data.top + (resolution.y * 0.5)), Vector2(data.right - (resolution.x * 0.5), data.bottom - (resolution.y * 0.5)))
		
		_smooth_damp(damped_pan, position_goal, data.panSmoothing, delta)
		target.position = damped_pan[0]

func _unhandled_input_component(event: InputEvent) -> void:
	if !enabled:
		return
	if not event is InputEventMouse and not event is InputEventAction:
		return
	
	var current_mouse : Vector2 = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed(data.panAction) or (fallback_mouse_pan and Input.is_mouse_button_pressed(data.panButton)):
		position_goal += (last_mouse - current_mouse)
	
	if Input.is_action_just_pressed(data.zoomInAction) or (fallback_mouse_zoom_in and Input.is_mouse_button_pressed(data.zoomInButton)):
		zoom_goal *= 1.0 / (1.0 - data.zoomStepRatio)
		zoom_mouse = get_viewport().get_mouse_position()
		zoom_mouse -= get_viewport().get_visible_rect().size * 0.5
		
	if Input.is_action_just_pressed(data.zoomOutAction) or (fallback_mouse_zoom_out and Input.is_mouse_button_pressed(data.zoomOutButton)):
		zoom_goal *= (1.0 - data.zoomStepRatio)
		zoom_mouse = get_viewport().get_mouse_position()
		zoom_mouse -= get_viewport().get_visible_rect().size * 0.5
	
	zoom_goal = zoom_goal.clamp(data.minZoom * Vector2.ONE, data.maxZoom * Vector2.ONE)
	last_mouse = current_mouse

func _physics_process_component(delta: float) -> void:
	pass

func _set_target() -> void:
	if not target and parent:
		target = parent
#endregion

#region Component Functions
func _smooth_damp(state : Array[Vector2], _target : Vector2, smoothTime : float, deltaTime : float):
	smoothTime /= 2.0
	
	var current : Vector2 = state[0]
	var linear_velocity : Vector2 = state[1]
	
	if smoothTime == 0:
		state[0] = _target
		state[1] = Vector2.ZERO
		return
		
	var omega : float = 2.0 / smoothTime
	
	var x : float = omega * deltaTime
	var expo : float = 1.0 / (1.0 + x + 0.48 * x * x +0.25 * x * x * x)
	
	var change : Vector2 = current - _target
	var originalTo : Vector2 = _target
	_target = current - change
	
	var temp : Vector2 = (linear_velocity + omega * change) * deltaTime
	linear_velocity = (linear_velocity - omega * temp) * expo
	var output : Vector2 = _target + (change + temp) * expo
	
	if (originalTo.x > current.x) == (output.x > originalTo.x):
		output.x = originalTo.x
		linear_velocity.x = (output.x - originalTo.x) / deltaTime
	if (originalTo.y > current.y) == (output.y > originalTo.y):
		output.y = originalTo.y
		linear_velocity.y = (output.y - originalTo.y) / deltaTime
	
	state[0] = output
	state[1] = linear_velocity
#endregion

#region Signal Functions
func _on_can_pan_and_zoom(value : bool) -> void:
	enabled = value
#endregion
