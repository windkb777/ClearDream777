extends Control

var dlls : PackedStringArray = []
var sel = null

func _ready():
	connectButton()

func connectButton():
	var dll = [$Ares,$Phobos,$DDraw,$Style,$Mods]
	for i in dll.size():
		dlls.append(dll[i].name)
		dll[i].connect("mouse_entered",func():sel = dll[i])
		dll[i].connect("gui_input",Sel_Press)

## 
func Sel_Press(event=InputEvent):
	if event is InputEventMouseButton and Input.is_action_just_pressed("L_Click"):
		var color = sel.get_theme_stylebox("normal")
		var a = [
			Color("5029b3ff"),Color("4132c7ff"),Color("2b88d9ff"),Color("d99100ff"),Color("00af56ff"),Color("333333ff"),
			Color("321676ff"),Color("2f2299ff"),Color("1666a9ff"),Color("9f6800ff"),Color("00823eff"),Color("1f1f1fff")]
		if color["bg_color"] != a[5]:color["bg_color"] = a[5];color["border_color"]=a.back()
		else:color["bg_color"] = a[sel.get_index()];color["border_color"]=a[sel.get_index()+6]
		if color["bg_color"]!=a[5]:dlls.append(str(sel.name))
		else:dlls.erase(str(sel.name))
		if !dlls.has("Ares"):
			dlls.erase("Phobos");
			get_child(1).get_theme_stylebox("normal")["bg_color"]=a[5]
			get_child(1).get_theme_stylebox("normal")["border_color"]=a.back()
		const t_ares = " [color=Crimson]Ares[/color] "
		const t_phobos = " [color=Slateblue]Phobos[/color] "
		const t_ddraw = " [color=Royalblue]DDraw[/color] "
		var mix = {"Ares"=t_ares,"Phobos"=t_phobos,"DDraw"=t_ddraw,"Style"="","Mods"=""}
		var _expand_dll = ""
		var dl = ""
		for i in dlls:
			dl+=i;dl+=","
			if dl.contains(i):
				_expand_dll+=mix[i]
		Soft.get_node("cmd").dll = dl.split(",")
		Soft.get_node("cmd").dll.erase("")
		Soft.get_node("cmd").expandDll()

func anime(info="",inn=0.06,out=0.06):
	var file_check = get_children()
	##anime
	var seeds = randi_range(1,99)
	for i in seeds:file_check.shuffle()
	if info=="show":
		for i in file_check:i.modulate.a = 0
		for i in file_check:
			Soft.play_sfx("sel_1")
			create_tween().tween_property(i,"modulate",Color(i.modulate.r,i.modulate.g,i.modulate.b,1),0.3265)
			await Soft.waitime(inn)
	if info=="hide":
		for i in file_check:
			Soft.play_sfx("sel_1")
			create_tween().tween_property(i,"modulate",Color(i.modulate.r,i.modulate.g,i.modulate.b,0),0.3265)
			await Soft.waitime(out)

func Read(names,file="",title=""):
	var group = get_tree().get_first_node_in_group(names)
	file = group.text
	title = str(group.get_groups()[0])
	return [names,file,title]

func menu_visible():
	#var engine = get_parent().get_node("B-Engine")
	var file = get_parent().get_node("file")
	
	if visible==false:
		file.visible=true
		#engine.hide();file.show()
		print("隐藏 正在显示")
	else:
		file.visible=false
		#engine.show();file.hide()
		print("显示状态 正在隐藏")

	#if info=="show":
		#hide()
		#if a.is_visible():create_tween().tween_property(a,"modulate",Color("00000000"),0.6)
		#await Soft.waitime(0.1)
		#show()
		#anime("show",0.04,0.04)
		#await Soft.waitime(0.8)
		#a.hide()
		#menu.text="隐藏目录"
	#if info=="hide":
		#anime("hide",0.03,0.03)
		#await Soft.waitime(0.2)
		###显示图形化UI功能
		##if Soft.ui==1:a.show();create_tween().tween_property(a,"modulate",Color("ffffff"),0.6)
		##elif Soft.ui==0:b.show();create_tween().tween_property(b,"modulate",Color("ffffff"),0.6)
		#await Soft.waitime(0.6)
		#hide()
		#menu.text="显示目录"
	#print(info," state")
