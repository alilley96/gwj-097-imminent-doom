class_name PlayerState
extends RefCounted

# Properties ----------------------------------------------------------------

var name: String
var health_threshold: float
var face_animation_name: String
var breathing_speed: float
var vignette_inner_radius: float
var vignette_outer_radius: float
var vignette_opacity: float


# Public functions ---------------------------------------------------------------- 

static func create(
	_name: String,
	_health_threshold: float,
	_face_animation_name: String,
	_breathing_speed: float,
	_vignette_inner_radius: float,
	_vignette_outer_radius: float,
	_vignette_opacity: float
	) -> PlayerState:
	var state := PlayerState.new()

	state.name = _name
	state.health_threshold = _health_threshold
	state.face_animation_name = _face_animation_name
	state.breathing_speed = _breathing_speed
	state.vignette_inner_radius = _vignette_inner_radius
	state.vignette_outer_radius = _vignette_outer_radius
	state.vignette_opacity = _vignette_opacity
	
	return state
