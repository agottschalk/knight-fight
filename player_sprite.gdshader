shader_type canvas_item;

global uniform vec4 tassle;
global uniform vec4 tassle_shadow;
instance uniform vec4 new_tassle : source_color = vec4(0.402, 0.02, 0.025, 1.0);
instance uniform vec4 new_shadow : source_color = vec4(0.242, 0.014, 0.017, 1.0);

varying vec4 modulate_color;

void vertex() {
	modulate_color = COLOR;
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	if(distance(pixel_color, tassle) < 0.0001){
		pixel_color = new_tassle;
	}else if(distance(pixel_color, tassle_shadow) < 0.0001){
		pixel_color = new_shadow;
	}
	COLOR = modulate_color * pixel_color;
}