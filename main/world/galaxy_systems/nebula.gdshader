shader_type canvas_item;

// The noise texture from the Inspector
uniform sampler2D noise_img : repeat_enable, filter_linear;

// Colors and look
uniform vec4 color_1 : source_color = vec4(0.1, 0.05, 0.2, 1.0);
uniform vec4 color_2 : source_color = vec4(0.4, 0.1, 0.6, 1.0);
uniform float brightness : hint_range(0.0, 5.0) = 1.2;
uniform float clouds_density : hint_range(0.0, 2.0) = 1.0;

// Movement and Scale
uniform float uv_scale : hint_range(0.1, 5.0) = 1.0;
uniform vec2 scroll_speed = vec2(0.01, 0.01);

void fragment() {
	// Base UVs scaled and moving over time
	vec2 base_uv = UV * uv_scale;
	vec2 moving_uv = base_uv + (TIME * scroll_speed);
	
	// Sample the noise texture twice for a "liquid" warping effect
	// Layer 1: The base clouds
	float noise_r = texture(noise_img, moving_uv).r;
	
	// Layer 2: Distorted by Layer 1 to create wispy tendrils
	float noise_g = texture(noise_img, moving_uv + noise_r * 0.1).r;
	
	// Mix colors based on the second noise layer
	vec3 nebula_color = mix(color_1.rgb, color_2.rgb, noise_g);
	
	// Apply density using a smoothstep for cleaner "cloud" edges
	float alpha = smoothstep(0.2, 0.8, noise_g * clouds_density);
	
	COLOR = vec4(nebula_color * brightness, alpha);
}