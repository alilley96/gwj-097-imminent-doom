class_name GameController
extends Node2D

# Exports ----------------------------------------------------------------

@export var input_controller: InputController
@export var spiral_controller: SpiralController
@export var player: Player


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	player.no_health.connect(_game_over)
	
	input_controller.rotate_clockwise.connect(_rotate_spirals_clockwise)
	input_controller.rotate_counter_clockwise.connect(_rotate_spirals_counter_clockwise)
	
	spiral_controller.damage.connect(_apply_damage)
	spiral_controller.heal.connect(_regen_health)


# Private functions ----------------------------------------------------------------

func _game_over() -> void:
	print("Game Over!")
	
	
func _rotate_spirals_clockwise() -> void:
	spiral_controller.rotate_spirals_clockwise()
	

func _rotate_spirals_counter_clockwise() -> void:
	spiral_controller.rotate_spirals_counter_clockwise()


func _apply_damage(amount: float) -> void:
	player.apply_damage(amount)


func _regen_health(amount: float) -> void:
	player.regen_health(amount)
