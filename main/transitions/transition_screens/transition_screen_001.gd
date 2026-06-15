extends Control

#region Signals
signal transition_finished()
#endregion

#region Export Variables
@export var transition_texture : Control
@export var animation_player : AnimationPlayer
@export var animation_track : String = "transition_progress"
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name = "TransitionScreen"
	z_index = 10

func start_transition() -> void:
	Static.printc(self.name, Color.CORNFLOWER_BLUE, "Transition started.")

	animation_player.play(animation_track)
	await animation_player.animation_finished
	
	Static.printc(self.name, Color.CORNFLOWER_BLUE, "Transition finished.")
	transition_finished.emit()

func take_screenshot() -> void:
	var viewport : Viewport = get_viewport()
	var _current_screenshot : Texture2D = ImageTexture.create_from_image(viewport.get_texture().get_image())

	Static.printc(self.name, Color.AQUA, "Screenshot taken:", _current_screenshot)

	#transition_texture.texture = null
	transition_texture.texture = _current_screenshot
	Static.printc(self.name, Color.AQUA, "Screenshot applied to texture:", _current_screenshot)
