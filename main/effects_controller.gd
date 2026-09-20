class_name EffectsController
extends Node

# Exports ----------------------------------------------------------------

@export var vignette: ColorRect


# Constants ----------------------------------------------------------------

const VIGNETTE_FADING_FACTOR: float = 5.0
const VIGNETTE_RED_AMOUNT: float = 0.5

# Private Variables ----------------------------------------------------------------

@onready var _vignette_material: ShaderMaterial = vignette.material
var _vignette_outer_radius: float = 0.5
var _vignette_inner_radius: float = 0.25
var _vignette_opacity: float = 0.5


# Lifecycle Functions ----------------------------------------------------------------

func process(delta: float) -> void:
	_vignette_material.set_shader_parameter("inner_radius", _vignette_inner_radius)
	_vignette_material.set_shader_parameter("outer_radius", _vignette_outer_radius)
	_vignette_material.set_shader_parameter("opacity", _vignette_opacity)


# Public Functions ----------------------------------------------------------------

func tick(delta: float) -> void:
	_vignette_material.set_shader_parameter("outer_radius", lerp(_vignette_material.get_shader_parameter("outer_radius"), _vignette_outer_radius, delta * VIGNETTE_FADING_FACTOR))
	_vignette_material.set_shader_parameter("inner_radius", lerp(_vignette_material.get_shader_parameter("inner_radius"), _vignette_inner_radius, delta * VIGNETTE_FADING_FACTOR))
	_vignette_material.set_shader_parameter("opacity", lerp(_vignette_material.get_shader_parameter("opacity"), _vignette_opacity, delta * VIGNETTE_FADING_FACTOR))
	_vignette_material.set_shader_parameter("red_amount", lerp(_vignette_material.get_shader_parameter("red_amount"), 0.0, delta * VIGNETTE_FADING_FACTOR))
	

func pulse_red_vignette() -> void:
	_vignette_material.set_shader_parameter("red_amount", VIGNETTE_RED_AMOUNT)


func update_vignette(inner_radius: float, outer_radius: float, opacity: float) -> void:
	_vignette_inner_radius = inner_radius
	_vignette_outer_radius = outer_radius
	_vignette_opacity = opacity
