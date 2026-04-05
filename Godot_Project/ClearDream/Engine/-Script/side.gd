extends Control
## Flag Ico Path = "res://x.Plugin/UI_Flags/"
## .Pck Format
## Size 45x20



func Bind():
	var nodes = [$"Side".get_children(),$"Flag",get_children(),$"NewSet".get_children()]
	for i in nodes[0]:
		i.connect("pressed",Inside.bind(i))
		
	
	#for i in side:
		#if i is Button:
			#i.connect("pressed",Inside.bind(i))
			#print(i.name)

func Inside(obj):
	if obj.name.contains("side"):
		var sides = obj.get_parent().get_children()
		var sideName = obj.get_child(0).text
		for i in sides:i.modulate=Color("434343ff")
		obj.modulate = Color.WHITE
		match sideName:
			"GDI":pass
			"NOD":pass
		
	match obj.name:
		"addSet":subwindow("400x320",0)

func subwindow(sizes:String,ui:int):
	var sub = load("res://Engine/-inside-/Confirm.tscn").instantiate()
	## Set Size and Position
	sub.size=Vector2(sizes.split("x")[0].to_int(),sizes.split("x")[1].to_int())
	sub.pivot_offset=sub.size / 2;sub.position = sub.size - Vector2(160,255)
	sub.get_child(2).position=sub.size-Vector2(145,50)
	sub.get_child(3).position=Vector2(sub.get_child(2).position.x+66,sub.get_child(2).position.y)
	## Add Window
	add_child(sub)
	## Set type
	sub.UI=ui
	sub.option_selected(0)
