class_name HudController
extends CanvasLayer

# Exports ----------------------------------------------------------------

@export var timer_label: Label
@export var health_bar: ProgressBar
@export var health_bar_label: Label


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	disable()


# Public functions ----------------------------------------------------------------

func enable() -> void:
	timer_label.visible = true
	health_bar.visible = true


func disable() -> void:
	timer_label.visible = false
	health_bar.visible = false


func update_health(health: float) -> void:
	health_bar.value = health
	health_bar_label.text = String.num(health, 1) + "hp"
	health_bar_label.visible = true
	health_bar.visible = true


func update_timer(timer: float) -> void:
	timer_label.text = String.num(timer, 1) + "s"
