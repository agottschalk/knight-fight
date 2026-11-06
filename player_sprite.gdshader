shader_type canvas_item;

varying vec4 modulate_color;

void vertex() {
	modulate_color = COLOR;
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	COLOR = modulate_color * pixel_color;
}