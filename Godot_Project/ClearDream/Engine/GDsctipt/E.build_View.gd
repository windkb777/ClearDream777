extends Window

func _ready():
	ConnectButtons()

#func Calc():
	## 图像源代码在Godot中 使用的格式为PackedByteArray
	## 计算方式为(Width x Height) / 3
	## RGB8 = Color(255,255,255)
	## 287316 95772
	#var Byte = $BackGround/Image.texture.get_image().data
	#for i in Byte.data.size() / 3:
		#var r = Byte.data[i]
		#var g = Byte.data[i+1]
		#var b = Byte.data[i+2]
		#var color = Color8(r,g,b).to_html()
		#if i>95750:print_rich("[bgcolor=%s]   [/bgcolor]"%color)

#func _input(event):
	#if event is InputEventMouseButton:
		#for i in mouse.get_children():
			#$View/Scale.text = str(snappedf(mouse.scale.x,0.1))+"x"
			#if Input.is_action_just_pressed("MUP"):mouse.scale += 0.025 * Vector2.ONE
			#elif Input.is_action_just_pressed("MDown"):mouse.scale -= 0.025 * Vector2.ONE

func ConnectButtons():
	connect("close_requested",queue_free)
	for i in [$Board.get_node("Buttons/Custom1"),$Board.get_node("Buttons/Custom2")]:i.connect("pressed",Buttons.bind(i))
	for i in $"1_Build".get_children()+$"2_Unit".get_children()+$View.get_children():
		if i is Button or i is TextureButton:i.connect("pressed",Buttons.bind(i))
	show()


func Buttons(node):
	ViewerSet(node)
	BuildState(node)

func ViewerSet(obj):
	var view = "Eye/Grid/Bar/Scale/Color/Build/Unit".split("/")
	var group = [$View/Map,$View/Pos/GridA,$View/Pos/UI,$View/Pos,$View/Pos/Image,$"1_Build",$"2_Unit"]
	for i in 7:
		if view[i]==obj.name:
			if obj.is_pressed():group[i].show()
			else:group[i].hide()
	## UI Change
	if obj is Button and (obj.text.contains("Build") or obj.text.contains("Unit")):
		group[5].hide();group[6].hide()
		if obj.text=="Build":group[5].show()
		if obj.text=="Unit":group[6].show()
func BuildState(obj):
	var Location = $View/Pos
	var image = Location.get_node("Image")
	var shadow = Location.get_node("Shadow")
	const shadowOffset = 4
	var buttons = [$"1_Build/Smoke",$"1_Build/OpenFire",$"1_Build/OnFire"]
	var layer = [$View/Pos/Smoke,$View/Pos/Fire,$View/Pos/DamageFireOffset,$View/Pos/Explosion]
	## ON/OFF
	#var switch = obj.get_index()-8
	#if switch < 3 and switch > -1:ShowOrHide(switch)
	for i in 3:layer[i].hide()	
	## SetState
	match obj.name:
		"Build":print("building!!!")
		"Ready":
			PipHealth(16)
			image.frame=0
		"Defend":
			layer[1].show()
			PipHealth(8)
			image.frame=2
		"Broke":
			layer[2].show()
			PipHealth(5)
			image.frame=1
		"Explosion":
			PipHealth(1)
			image.frame=3
	shadow.frame = image.frame + shadowOffset

#func ShowOrHide(button,layer):
	#if !button.is_visible():button.show()
	#else:button.hide()
	#var buttons = [$"1_Build/Smoke",$"1_Build/OpenFire",$"1_Build/OnFire",null]
	#var object = [$View/Pos/Smoke,$View/Pos/Fire,$View/Pos/DamageFireOffset,$View/Pos/Explosion]
	### Hide Fx
	#for i in object:i.hide()
	### Change
	#if buttons[num]!=null:
		### Change Button Text ON/OFF
		#if buttons[num].text.contains("OFF"):buttons[num].text=buttons[num].text.replace("OFF","ON")
		#else:buttons[num].text=buttons[num].text.replace("ON","OFF")
		### Change Fx Visible
		#if buttons[num].text.contains("ON"):object[num].show()
		#else:object[num].hide()

func PipHealth(num,health=$View/Pos/UI/Health):
	## HealthBar Set
	for h in health.get_children():
		h.frame = 0
		if num > h.get_index():
			h.frame = 1
			match num:
				16:h.frame = 1
				8:h.frame = 2
				5:h.frame = 4
				1:health.hide()
####  1.读取图像  2.查看动画  3.调整特效  4.基本设置  5.导出文件
