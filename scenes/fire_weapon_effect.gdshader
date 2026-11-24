shader_type canvas_item;

instance uniform float palette_index;
uniform float number_of_palettes = 2.0;
uniform sampler2D color_palette : filter_nearest;

varying vec4 modulate_value;

void vertex() {
	modulate_value = COLOR;
}

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	float v = (1.0 / number_of_palettes) * (palette_index + 0.5);
	vec4 pixel_color = texture(color_palette, vec2(base_color.r, v));
	pixel_color.a = base_color.a;
	COLOR = pixel_color * modulate_value;
}
