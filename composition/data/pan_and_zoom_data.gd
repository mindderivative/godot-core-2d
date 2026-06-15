## Data resource for the [PanAndZoomComponent].
class_name PanAndZoomData extends Data

#region Exported Parameters
@export_range(1, 20, 0.01) var maxZoom : float = 5.0
@export_range(0.01, 1, 0.01) var minZoom : float = 0.1
@export_range(0.01, 0.2, 0.01) var zoomStepRatio : float = 0.1

@export_group("Actions")
@export var panAction : String = "panAction"
@export var zoomInAction : String = "zoomInAction"
@export var zoomOutAction : String = "zoomOutAction"

@export_group("Mouse")
@export var zoomToCursor: bool = true
@export_enum("Auto", "Always", "Never") var useFallbackButtons: String = "Auto"
@export var panButton : MouseButton = MOUSE_BUTTON_RIGHT
@export var zoomInButton : MouseButton = MOUSE_BUTTON_WHEEL_UP
@export var zoomOutButton : MouseButton = MOUSE_BUTTON_WHEEL_DOWN

@export_group("Smoothing")
@export_range(0, 0.99, 0.01) var panSmoothing : float = 0.5:
	set(new_value):
		panSmoothing = pow(new_value, slider_exponent)
	get:
		return panSmoothing
@export_range(0, 0.99, 0.01) var zoomSmoothing : float = 0.5:
	set(new_value):
		zoomSmoothing = pow(new_value, slider_exponent)
	get:
		return zoomSmoothing

@export_group("Limits")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var limits_enabled : bool = false
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var left : int = -10000000
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var top : int = -10000000
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var right : int = 10000000
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bottom : int = 10000000



# To make the sliders be pleasantly non-linear
const slider_exponent : float = 0.25

# To make the smoothing ratios framerate-independent
const referenceFPS : float = 120.0
#endregion
