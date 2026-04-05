shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.1,0.1,0.1,1);
uniform vec4 line_color : source_color = vec4(0.16,0.16,0.16,1.0);
uniform int filas : hint_range(1, 100) = 20;
uniform int columnas : hint_range(1, 100) = 30;

void fragment() {
	float tamano_cuadro = 40.0;
    vec2 tamano_total = vec2(float(columnas) * tamano_cuadro, float(filas) * tamano_cuadro);
    vec2 pos = UV * tamano_total;
    vec2 celda = pos / tamano_cuadro;
    float umbral = 0.05;
    float linea_x = mod(celda.x, 1.0) < umbral ? 1.0 : 0.0;
    float linea_y = mod(celda.y, 1.0) < umbral ? 1.0 : 0.0;
    float grid = max(linea_x, linea_y);
    
    COLOR = mix(bg_color, line_color, grid);
}
