shader_type canvas_item;

uniform vec2 flow_direction = vec2(1.0, 0.0);
uniform vec2 zone_min = vec2(-120.0, -100.0);
uniform vec2 zone_size = vec2(240.0, 200.0);
varying vec2 local_position;

void vertex() {
	// Local pixel coordinates also work on polygons with no texture.
	local_position = VERTEX;
}

void fragment() {
	vec2 point = local_position - zone_min;
	vec2 edge_distance = min(point, zone_size - point);
	float edge = min(edge_distance.x, edge_distance.y);
	float fade = smoothstep(0.0, 6.0, edge);
	float along = dot(point, flow_direction);
	float across = dot(point, vec2(-flow_direction.y, flow_direction.x));
	float travel = along - TIME * 65.0;

	// Narrow streaks and bubbles move along the flow, at constant visual speed.
	float lane = mod(across + sin(along * 0.018 - TIME) * 3.0, 34.0);
	float streak = (1.0 - smoothstep(0.7, 1.8, abs(lane - 17.0)))
		* smoothstep(0.2, 0.8, 0.5 + 0.5 * sin(travel * 0.065));
	vec2 bubble_cell = vec2(mod(travel, 94.0) - 47.0, lane - 17.0);
	float bubble = 1.0 - smoothstep(0.45, 1.1, abs(length(bubble_cell) - 2.5));

	// Small repeated chevrons establish direction even in a still frame.
	vec2 arrow_cell = vec2(mod(along, 140.0) - 70.0, mod(across, 102.0) - 51.0);
	float chevron = (1.0 - smoothstep(0.8, 1.8, abs(arrow_cell.x + abs(arrow_cell.y) - 6.0)))
		* (1.0 - smoothstep(7.0, 10.0, abs(arrow_cell.y)));
	// Broken, soft perimeter marks the exact area without an opaque rectangle.
	float rim = (1.0 - smoothstep(2.0, 7.0, edge))
		* smoothstep(-0.3, 0.3, sin((point.x + point.y) * 0.10));
	float alpha = fade * (0.10 + streak * 0.28 + bubble * 0.38 + chevron * 0.24 + rim * 0.28);
	COLOR = vec4(0.35, 0.79, 0.9, alpha);
}
