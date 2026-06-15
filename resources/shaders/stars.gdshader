shader_type canvas_item;

uniform vec3 star_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float density : hint_range(1.0, 50.0) = 20.0; // Higher = more stars
uniform float size_range : hint_range(0.01, 1.0) = 0.2;
uniform float twinkle_speed : hint_range(0.0, 5.0) = 1.0;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

// Simple hash for randomness
float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

void fragment() {
	// Scale UVs based on density
	vec2 grid_uv = UV * density;
	vec2 id = floor(grid_uv); // Unique ID for each grid cell
	vec2 local_uv = fract(grid_uv) - 0.5; // UVs from -0.5 to 0.5 inside cell
	
	// Random offset for the star within the cell
	float h = hash(id);
	vec2 offset = vec2(h - 0.5, hash(id + 1.0) - 0.5) * 0.8;
	
	// Calculate distance to the star point
	float dist = length(local_uv - offset);
	
	// Vary size based on the cell ID
	float star_size = h * size_range;
	
	// Twinkle effect using TIME
	float twinkle = sin(TIME * twinkle_speed + h * 6.28) * 0.5 + 0.5;
	
	// Draw the star (soft circle)
	float star_light = smoothstep(star_size, 0.0, dist);
	
	// Apply color, twinkle, and brightness
	vec3 final_color = star_color * star_light * twinkle * brightness;
	
	COLOR = vec4(final_color, star_light);
}