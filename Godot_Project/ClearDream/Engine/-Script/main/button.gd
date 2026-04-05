extends Control

var ui_color_num : int = 0

func Bind():
	var button = get_children()
	for i in button:i.connect("pressed",Buttons.bind(i.name))

## Button Function
func Buttons(names):
	#Soft.play_sfx("sel_2")
	match names:
		#"ra2":ChangeUI(names)
		#"yuri":ChangeUI(names)
		"code":
			if $code.is_pressed():print("Code Mode Turn ON!!")
			else:print("Code Mode Turn OFF!")
		"paint":color_theme()
		#"play":Soft.Tool[1].Play_Option()
		#"debug":Soft.Tool[1].Debug_Option()
		"about":
			$"../Engine/tv".hide()
			print("Write About SomeThing")
		"bat":
			if $bat.is_pressed():print("Write OFF")
			else:print("Write ON")
		"window":
			if $window.is_pressed():Soft.Tool[1].Windowed("true ");print("Windowed")
			else:Soft.Tool[1].Windowed("false");print("FullScreen")
		"file":
			if $file.is_pressed():$"../Panel/file".show();$"../Engine".hide()
			else:$"../Panel/file".hide();$"../Engine".show()#$file.menu_visible()
		"close":
			Soft.play_sfx("sel_1")
			await Soft.waitime(0.3)
			get_tree().quit()
## Funcs
func color_theme():
	const cdr = [
		Color("4f1dadff"),Color("24036bff"),Color("004ab8ff"),Color("c500d2"),Color("0061e1"),
		Color("ad1d1dff"),Color("6b0303ff"),Color("b80000ff"),Color("f06100ff"),Color("e03c00ff"),
		Color("1dad3dff"),Color("036b16ff"),Color("00b834ff"),Color("789f00ff"),Color("064f00ff")]
	const play_color=[Color("f48f00"),Color("f50800ff"),Color("005c03ff"),Color("0056f5"),Color("a10003ff"),Color("006e1bff")]
	var colors = $"../Panel/Title".get_theme_stylebox("panel")["texture"]["gradient"]
	var node = [$"../Panel/line",$paint,$close,$play,$debug]
	const sort=[[2,3,4],[7,8,9],[12,13,14]]
	ui_color_num+=1
	if ui_color_num==3:ui_color_num=0
	for i in 2:colors["colors"][i]=cdr[i+(ui_color_num*5)]
	node[0].default_color=cdr[sort[0+ui_color_num][0]]
	node[1].modulate=cdr[sort[0+ui_color_num][1]]
	node[2].modulate=cdr[sort[0+ui_color_num][2]]
	node[3].get_theme_stylebox("normal")["bg_color"]=play_color[ui_color_num]
	node[4].get_theme_stylebox("normal")["bg_color"]=play_color[ui_color_num+3]
func ChangeUI(who,change=false):
	var node=[$"../Panel/undo",$"../Panel/file",$"../Engine"]
	match who:
		"ra2":Soft.ui=0
		"yuri":Soft.ui=1
	if change:
		if Soft.ui==0:Soft.ui+=1
		else:Soft.ui=0
	for i in 4:
		node[i].hide()
		match Soft.ui:
			0:node[0].show()
			1:node[3].show()
