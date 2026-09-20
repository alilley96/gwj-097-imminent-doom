class_name GameController
extends Node2D

# Exports ----------------------------------------------------------------

@export var input_controller: InputController
@export var spiral_controller: SpiralController
@export var ui_controller: UIController
@export var effects_controller: EffectsController
@export var audio_controller: AudioController
@export var player: Player
@export var timer_label: Label


# Private Variables ----------------------------------------------------------------

var _game_over: bool = true
var _game_paused: bool = true
var _game_timer: float = 0.0


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	player.no_health.connect(_set_game_over)
	player.state_changed.connect(_player_state_changed)
	_player_state_changed(PlayerStates.CONTENT)
	
	input_controller.rotate_clockwise.connect(_rotate_spirals_clockwise)
	input_controller.rotate_counter_clockwise.connect(_rotate_spirals_counter_clockwise)
	input_controller.pause.connect(_toggle_pause)
	
	spiral_controller.damage.connect(_apply_damage)
	spiral_controller.completed.connect(_spiral_completed)

	ui_controller.play.connect(_start)
	ui_controller.quit.connect(_quit)

	audio_controller.play_music("main_menu")


func _process(delta: float) -> void:
	if _game_paused:
		return

	player.tick()
	spiral_controller.tick(delta)
	effects_controller.tick(delta)

	_game_timer += delta
	timer_label.text = String.num(_game_timer, 2) + "s"
	
	
# Private functions ----------------------------------------------------------------

func _start() -> void:
	_game_over = false
	_pause(false)

	ui_controller.disable()
	spiral_controller.spiral_spawn_timer.start()
	spiral_controller.spiral_spawn_timer.paused = false

	_game_timer = 0.0
	audio_controller.play_music("content")


func _quit() -> void:
	pass


func _toggle_pause() -> void:
	if not _game_over:
		_pause(not _game_paused)


func _pause(pause: bool) -> void:
	_game_paused = pause
	spiral_controller.spiral_spawn_timer.paused = pause

	if _game_paused:
		ui_controller.enable()
	else:
		ui_controller.disable()


func _set_game_over() -> void:
	_pause(true)
	_game_over = true

	ui_controller.visible = true
	
	
func _rotate_spirals_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_clockwise()
	

func _rotate_spirals_counter_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_counter_clockwise()


func _apply_damage(amount: float) -> void:
	player.apply_damage(amount)


func _spiral_completed(heal_amount: float) -> void:
	player.regen_health(heal_amount)
	audio_controller.play_pop_sfx()
	
	
func _player_state_changed(state: PlayerState) -> void:
	effects_controller.update_vignette(
		state.vignette_inner_radius,
		state.vignette_outer_radius,
		state.vignette_opacity,
	)
	audio_controller.play_music(state.name)
