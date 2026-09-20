class_name GameController
extends Node2D

# Exports ----------------------------------------------------------------

@export var input_controller: InputController
@export var spiral_controller: SpiralController
@export var menu_controller: MenuController
@export var effects_controller: EffectsController
@export var audio_controller: AudioController
@export var hud_controller: HudController
@export var player: Player

@export var score_label: Label

# Private Variables ----------------------------------------------------------------

var _game_over: bool = true
var _game_paused: bool = true
var _game_timer: float = 0.0
var _high_score: float = 0.0


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

	menu_controller.play.connect(_play_button_pressed)
	menu_controller.quit.connect(_quit)
	menu_controller.enable()

	audio_controller.play_music("main_menu")
	_set_pause_vignette()

	score_label.visible = false


func _process(delta: float) -> void:
	effects_controller.tick(delta)

	if _game_paused:
		return

	player.tick()

	_game_timer += delta

	hud_controller.update_health(player.health)
	hud_controller.update_timer(_game_timer)
	
	
# Private functions ----------------------------------------------------------------

func _start() -> void:
	_game_over = false
	_pause(false)

	spiral_controller.spiral_spawn_timer.start()
	spiral_controller.spiral_spawn_timer.paused = false

	_game_timer = 0.0
	audio_controller.play_music("content")

	hud_controller.enable()


func _quit() -> void:
	get_tree().quit()


func _toggle_pause() -> void:
	if not _game_over:
		_pause(not _game_paused)


func _pause(pause: bool) -> void:
	_game_paused = pause
	spiral_controller.pause(pause)

	if _game_paused:
		menu_controller.enable()
		hud_controller.disable()
		_set_pause_vignette()
	else:
		menu_controller.disable()
		hud_controller.enable()
		audio_controller.play_pop_sfx()
		effects_controller.update_vignette(
			player.current_state.vignette_inner_radius,
			player.current_state.vignette_outer_radius,
			player.current_state.vignette_opacity
		)


func _set_game_over() -> void:
	_game_over = true
	_pause(true)

	if _game_timer > _high_score:
		_high_score = _game_timer

	spiral_controller.reset()
	audio_controller.play_music("main_menu")
	score_label.text = "Score: " + String.num(_high_score, 1) + "s"
	score_label.visible = true

	
func _rotate_spirals_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_clockwise()
	

func _rotate_spirals_counter_clockwise() -> void:
	if not _game_paused:
		spiral_controller.rotate_spirals_counter_clockwise()


func _apply_damage(amount: float) -> void:
	player.apply_damage(amount)
	audio_controller.play_damage_sfx()
	effects_controller.pulse_red_vignette()


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


func _set_pause_vignette() -> void:
	effects_controller.update_vignette(
		PlayerStates.DOOMED.vignette_inner_radius,
		PlayerStates.DOOMED.vignette_outer_radius,
		PlayerStates.DOOMED.vignette_opacity
	)

func _reset() -> void:
	_game_timer = 0.0
	audio_controller.play_music("content")
	player.reset()
	spiral_controller.reset()
	score_label.visible = false


func _play_button_pressed() -> void:
	if _game_over:
		_reset()
		_start()
	else:
		_pause(false)
