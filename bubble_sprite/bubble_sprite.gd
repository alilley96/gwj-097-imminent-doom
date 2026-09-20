class_name BubbleSprite
extends AnimatedSprite2D

# Public functions  ----------------------------------------------------------------

func spawn() -> void:
	visible = true

	animation = "spawn"
	play()

	if not animation_finished.is_connected(_on_spawn_finished):
		animation_finished.connect(_on_spawn_finished)


func pop() -> void:
	animation = "pop"
	play()

	if not animation_finished.is_connected(_on_pop_finished):
		animation_finished.connect(_on_pop_finished)


# Private functions  ----------------------------------------------------------------	
	
func _on_pop_finished() -> void:
	animation_finished.disconnect(_on_pop_finished)
	visible = false


func _on_spawn_finished() -> void:
	animation_finished.disconnect(_on_spawn_finished)
	animation = "idle"
	play()
