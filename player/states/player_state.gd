class_name PlayerState
extends RefCounted

# Properties ----------------------------------------------------------------

var name: String
var health_threshold: float
var face_animation_name: String
var breathing_speed: float

# placeholders 
var background: Texture2D
var music: AudioStream


# Public functions ---------------------------------------------------------------- 

static func create(_name: String, _health_threshold: float, _face_animation_name: String, _breathing_speed: float) -> PlayerState:
	var state := PlayerState.new()

	state.name = _name
	state.health_threshold = _health_threshold
	state.face_animation_name = _face_animation_name
	state.breathing_speed = _breathing_speed
	
	return state
