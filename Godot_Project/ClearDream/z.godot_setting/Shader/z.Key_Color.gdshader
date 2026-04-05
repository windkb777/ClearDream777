shader_type canvas_item;

uniform vec4 Key_Color: source_color;
uniform float tolerance = 0.01;

void fragment(){
	vec4 BG = texture(TEXTURE,UV);
	vec4 hue = texture(TEXTURE,UV);
	if (distance(BG.rgb,Key_Color.rgb) < tolerance)
		BG.a=0.0;
		COLOR=BG;
}