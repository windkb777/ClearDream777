extends Node


func _process(delta):
	var nodes = get_children()
	for i in nodes:
		var font_size = i.get_theme_font_size("font_size")
		if font_size==16:
			pass
			#print("16 A")
		#elif i.get_theme_font_size("font_size")==20:
			#print("20 B")

func AICoreTheme(type):
	match type:
		"Title-Tag":pass
		"ListSlot":pass
		"Button":pass
		
