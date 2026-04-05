shader_type canvas_item;

uniform vec4 Key_Color: source_color;
uniform vec4 shift_color: source_color;
uniform float gray : hint_range(0,1) = 0;
uniform float tolerance = 0.01;

void fragment(){
	vec4 BG = texture(TEXTURE,UV);
	vec4 hue = texture(TEXTURE,UV);
	if (distance(BG.rgb,Key_Color.rgb) < tolerance)
		BG.a=0.0;
		COLOR=BG;
	COLOR.rgb = mix(COLOR.rgb, vec3(COLOR.r + COLOR.g + COLOR.b), 1);
	COLOR *= shift_color;
}