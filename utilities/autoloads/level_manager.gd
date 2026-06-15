extends Node

var main_menu : String
var galactic_system : String
var current_level : String
var previous_level : String

# Change the preload to match the LevelManagerData resource created
@onready var data : LevelManagerData = preload("uid://blyfvqiplc7nn")

func _ready() -> void:
	if data.main_menu:
		main_menu = data.main_menu
	if data.galactic_system:
		galactic_system = data.galactic_system

func get_level(name : String) -> String:
	if data.levels.has(name):
		return data.levels[name]
	
	return ""
