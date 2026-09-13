class_name GameController
extends Node2D

# Exports ----------------------------------------------------------------

@export var input_controller: InputController
@export var spiral_controller: SpiralController
@export var player: Player


# Private Variables ----------------------------------------------------------------

var _game_over: bool = true
var _game_paused: bool = false


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	player.no_health.connect(_set_game_over)
	
	input_controller.rotate_clockwise.connect(_rotate_spirals_clockwise)
	input_controller.rotate_counter_clockwise.connect(_rotate_spirals_counter_clockwise)
	input_controller.pause.connect(_toggle_pause)
	
	spiral_controller.damage.connect(_apply_damage)
	spiral_controller.heal.connect(_regen_health)

	_start()


func _process(delta: float) -> void:
	if _game_paused:
		return

	player.tick()
	spiral_controller.tick(delta)
	

# Private functions ----------------------------------------------------------------

func _start() -> void:
	_game_over = false
	_pause(false)


func _toggle_pause() -> void:
	if not _game_over:
		_pause(not _game_paused)


func _pause(pause: bool) -> void:
	_game_paused = pause
	spiral_controller.spiral_spawn_timer.paused = pause


func _set_game_over() -> void:
	_pause(true)
	_game_over = true
	
	
func _rotate_spirals_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_clockwise()
	

func _rotate_spirals_counter_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_counter_clockwise()


func _apply_damage(amount: float) -> void:
	player.apply_damage(amount)


func _regen_health(amount: float) -> void:
	player.regen_health(amount)
