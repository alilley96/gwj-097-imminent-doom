class_name BubbleButton
extends Button

# Exports ----------------------------------------------------------------

@export var bubble_sprite: AnimatedSprite2D
@export var button_text: String
@export var button_text_label: Label
@export var initial_scale: float = 1.0


# Private variables  ----------------------------------------------------------------

var _target_scale: float = initial_scale

# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	button_text_label.text = button_text
	_target_scale = initial_scale
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE * _target_scale, delta * 10.0)


# Public functions  ----------------------------------------------------------------

func spawn() -> void:
	bubble_sprite.visible = true
	button_text_label.visible = true

	bubble_sprite.animation = "spawn"
	bubble_sprite.play()

	if not bubble_sprite.animation_finished.is_connected(_on_spawn_finished):
		bubble_sprite.animation_finished.connect(_on_spawn_finished)


func pop() -> void:
	button_text_label.visible = false
	bubble_sprite.animation = "pop"
	bubble_sprite.play()

	if not bubble_sprite.animation_finished.is_connected(_on_pop_finished):
		bubble_sprite.animation_finished.connect(_on_pop_finished)


# Private functions  ----------------------------------------------------------------

func _on_mouse_entered() -> void:
	_target_scale = initial_scale * 1.2
	
	
func _on_mouse_exited() -> void:
	_target_scale = initial_scale
	
	
func _on_pop_finished() -> void:
	bubble_sprite.animation_finished.disconnect(_on_pop_finished)
	bubble_sprite.visible = false


func _on_spawn_finished() -> void:
	bubble_sprite.animation_finished.disconnect(_on_spawn_finished)
	bubble_sprite.animation = "idle"
	bubble_sprite.play()
