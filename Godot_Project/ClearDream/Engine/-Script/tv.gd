extends Control

func Bind():
	var tv = get_children()
	for i in tv:
		if i is not Panel:i.connect("pressed",TV_Press.bind(i))
		i.connect("mouse_entered",func():i.scale=Vector2(1.2,1.2);i.z_index=1;Soft.play_sfx("jump"))
		i.connect("mouse_exited",func():i.scale=Vector2.ONE;i.z_index=0)

## TV_Buttons
func TV_Press(node):
	## Tween Animation
	node.scale = Vector2(1.2,1.2);create_tween().tween_property(node,"scale",Vector2.ONE,0.066)
	## Windows
	hide();$"..".get_child(node.name.to_int()+1).show()


	#var ck = ""
	## Functions
	#match node.name.to_int():
		#1:ck = "Country"
		#2:print("2")
		#3:ck = "Hotkey"
		#4:ck = "Color"
		#5:ck = "Crate + Encounter"
		#6:print("6")
		#7:print("7")
		#8:print("8")
		#9:print("9")
		#10:print("10")
		#11:print("11")
		#12:ck = "AI_Core"
		#13:print("13")
		#14:print("14")
		#15:print("15")
		#16:print("16")
		#17:print("17")
		#18:print("18")
	#if !ck.is_empty():
		#await Soft.waitime(0.42)
		
		#var scene = load("res://Engine/-Editer/%s.tscn"%ck).instantiate()
		#get_parent().add_child(scene);scene.show();scene.OpenAnmi()
