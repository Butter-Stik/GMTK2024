shader_type canvas_item;

// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 circle_centre;
uniform float circle_radius;

bool point_is_in_circle(vec2 point) {
	vec2 normalised_point = point - circle_centre;
	return length(normalised_point) < circle_radius;
}

void fragment() {
	vec2 pixel_uv = UV * vec2(320.0, 180.0);

	if (!point_is_in_circle(floor(pixel_uv))) {
		COLOR = vec4(7.0/255.0, 8.0/255.0, 14.0/255.0, 1.0);
	} else {
		COLOR = texture(screen_texture, UV);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
