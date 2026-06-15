class_name SceneTransitionData extends Resource

@export_group("Transition Settings")
@export var transition_scene: PackedScene
@export var wait_for_input: bool = false
@export var input_action: String = "ui_accept"
@export var block_input_during_transition: bool = true
@export var pause_game_during_transition: bool = false

@export_subgroup("Audio Settings")
@export var transition_sound: AudioStream
@export var transition_volume_db: float = 0.0
@export var transition_music: AudioStream
@export var music_volume_db: float = 0.0
@export var music_fade_out_time: float = 1.0
@export var music_fade_in_time: float = 1.0
@export var music_loop: bool = true
@export var music_autoplay: bool = false
@export var music_start_position: float = 0.0
@export var music_bus: String = "Master"

@export_subgroup("Loading Screen Settings")
@export var loading_screen_scene: PackedScene
@export var wait_for_input_during_loading: bool = false
@export var input_action_during_loading: String = "ui_accept"
@export var block_input_during_loading: bool = true
@export var pause_game_during_loading: bool = false
