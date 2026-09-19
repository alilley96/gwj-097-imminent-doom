
shader_type canvas_item;

uniform float opacity = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

void fragment() {
	vec2 distance_from_center = abs(UV - 0.5) * 2.0;
	float radius = length(distance_from_center);
	
	float darkness = clamp(
		(radius - inner_radius) / (outer_radius - inner_radius),
		0.0,
		1.0
	);
	
	COLOR = vec4(0.0, 0.0, 0.0, darkness * opacity);
}