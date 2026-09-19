@tool
class_name SpiralMaze
extends StaticBody2D

# Signals

signal completed()


# Exports ----------------------------------------------------------------

@export var maze_end_area: Area2D
@export var ball_spawn_point: Node2D


# Constants ----------------------------------------------------------------

const LINE_WIDTH: float = 30.0
const SEGMENT_COUNT: int = 30
const BASE_RADIUS: float = 250.0
const GAP_SEGMENT_COUNT: int = 3


# Public Functions -----------------------------------------------------------------

func spawn() -> void:
	_generate_maze(3)
	maze_end_area.body_entered.connect(_maze_completed)


# Private Functions -----------------------------------------------------------------

func _maze_completed(_body: Node2D) -> void:
	if _body is RigidBody2D:
		completed.emit()


func _generate_maze(ring_count: int) -> void:
	var outermost_ring: Line2D

	for i in range(ring_count):
		var scale_factor = i + 1
		var radius = scale_factor * BASE_RADIUS
		var segments = (scale_factor * SEGMENT_COUNT)
		var gap_segments = scale_factor * GAP_SEGMENT_COUNT

		var ring := _generate_ring(radius, segments, gap_segments)
		var collision_polygon := _generate_collision_polygon(ring.points)

		var random_rotation = randi_range(0, 360)
		ring.rotation = random_rotation
		collision_polygon.rotation = random_rotation

		add_child(ring)
		add_child(collision_polygon)

		outermost_ring = ring

	var maze_exit := _generate_maze_exit(outermost_ring.points)
	maze_exit.rotation = outermost_ring.rotation

	maze_end_area.add_child(maze_exit)


func _generate_maze_exit(points: PackedVector2Array) -> CollisionPolygon2D:
	var exit_point_1 = points[0]
	var exit_point_2 = points[-1]

	var exit_point_1_direction = exit_point_1.normalized()
	var exit_point_2_direction = exit_point_2.normalized()


	var exit_polygon: PackedVector2Array = [
		exit_point_2 + exit_point_2_direction * LINE_WIDTH / 2,
		exit_point_1 + exit_point_1_direction * LINE_WIDTH / 2,
		exit_point_1 - exit_point_1_direction * LINE_WIDTH / 2,
		exit_point_2 - exit_point_2_direction * LINE_WIDTH / 2
	]
	
	var maze_exit := CollisionPolygon2D.new()
	maze_exit.polygon = exit_polygon


	return maze_exit


func _generate_ring(radius: float, segments: int, gap_segments: int) -> Line2D:
	var line := Line2D.new()
	line.width = LINE_WIDTH
	line.default_color = Color.BLACK
	
	for i in range(segments - gap_segments):
		var radian = (PI / 180) * (360 / float(segments)) * i
		var radian_position = Vector2(cos(radian), sin(radian)) * radius
		
		line.add_point(radian_position)

	return line


func _generate_collision_polygon(points: PackedVector2Array) -> CollisionPolygon2D:
	var collider := CollisionPolygon2D.new()

	var outer_points: PackedVector2Array = []
	var inner_points: PackedVector2Array = []
	
	for point in points:
		var direction := point.normalized()
		outer_points.append(point + direction * LINE_WIDTH / 2)
		inner_points.append(point - direction * LINE_WIDTH / 2)
		
	var polygon := PackedVector2Array()
	
	for outer_point in outer_points:
		polygon.append(outer_point)
	
	var reversed_inner_points = _reverse_array(inner_points)
	for inner_point in reversed_inner_points:
		polygon.append(inner_point)
		
	collider.polygon = polygon

	return collider


func _reverse_array(array: PackedVector2Array) -> PackedVector2Array:
	var reversed_array = PackedVector2Array()

	for i in range(array.size() - 1, -1, -1):
		reversed_array.append(array[i])

	return reversed_array
