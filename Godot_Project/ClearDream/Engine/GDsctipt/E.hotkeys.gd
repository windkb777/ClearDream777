#@tool
extends Window

# 地图书签 编队
# View/SetView/Taunt/TeamCreate/TeamCenter/TeamSelect/TeamAddSelect
#var SetRa2Numkeys={View=4,Taunt=8,Team=10}

const counm = "建筑/防御/步兵/车辆/设置/修复/变卖/路径/部署/停止/分散/喝彩/警戒/信标/上一个/下一个/跟随/类型/基地/全选/事件/删除/地图
快照/屏幕\n截图/FPS\n显示/物体\n信息/伤害\n显示/切换\n数字/单帧\n模式/FPS\n1/FPS\n5/FPS\n10/FPS\n15/FPS\n30/FPS\n60"
const keyboard = "Q/W/E/R/ESC/K/L/Z/D/S/X/C/G/B/N/M/F/T/H/P/Space/Del"

@onready var keysets = $"-Ra2Keys/V1/Flow".get_children()
@onready var ebc = [$Flow/A.get_theme_stylebox("normal"),$Flow/B.get_theme_stylebox("normal"),$Flow/C.get_theme_stylebox("normal"),$Flow/D.get_theme_stylebox("normal"),$Flow/E.get_theme_stylebox("normal")]
@onready var color = $color
var lastkey = "F1"
var sel = null
var cmd = {Board="",Nums="",Obj=""}

func _ready():
	show()
	var buttons = $"-Ra2Keys/V1/Flow".get_children()
	for i in buttons:
		i.connect("mouse_entered",func():sel=i)
		i.connect("mouse_exited",func():sel=null)
	#HotKeys()

func _input(event):
	Soft.DragWindows(event,self)
	KeyBoard(event)
	Mouse()

func Mouse():
	if Input.is_action_just_pressed("L_Click") and sel!=null:
		SetButton()
		ColorChangeBack()
		#print(sel.text,"\n",sel.name)
func KeyBoard(event):
	if event is not InputEventMouse:
		var key = event.keycode
		var code = event.as_text()
		var keys = $KeyBoard.get_node(code)
		lastkey = code
		if event.is_pressed() and keys!=null:
			color.show()
			color.reparent(keys)
			color.position = Vector2.ZERO
			color.size = keys.size
			keys.clip_children = 2
			SetKey(code)
			#print(code," ",key)
		else:color.hide()
		cmd.Board=code;cmd.Nums=key;cmd.Obj=keys
func SetKey(presskey):
	var Sets = $Setting/SetButton
	for i in keysets:
		if i.get_theme_stylebox("normal")["bg_color"]==Color("dc008e"):
			var Press = i.editor_description.split("/")[0] + "\n" + presskey
			Sets.text = Press; i.editor_description = i.editor_description.split("/")[0]+"/"+presskey;i.text=Press
	## Release Button
	$Setting/SetButton.text = "未设置"
	$Setting/SetButton.get_theme_stylebox("normal")["bg_color"]=Color("86918fff")
	$Setting/SetButton.get_theme_stylebox("normal")["border_color"]=Color("545d5bff")
	## 还原未选择的颜色
	for i in keysets:
		var idx = i.get_index()
		var ibc = i.get_theme_stylebox("normal")
		if ibc["bg_color"]==Color("dc008e") and $Setting/SetButton.text!=i.text:
			if idx<8:ibc["bg_color"]=ebc[0]["bg_color"];ibc["border_color"]=ebc[0]["border_color"]
			elif idx>7 and idx<16:ibc["bg_color"]=ebc[1]["bg_color"];ibc["border_color"]=ebc[1]["border_color"]
			elif idx>15 and idx<22:ibc["bg_color"]=ebc[2]["bg_color"];ibc["border_color"]=ebc[2]["border_color"]
			elif idx>21 and idx<40:ibc["bg_color"]=ebc[3]["bg_color"];ibc["border_color"]=ebc[3]["border_color"]

func SetButton():
	## 设置选中的按钮
	for i in keysets:
		var ibc = i.get_theme_stylebox("normal")
		var sbc = sel.get_theme_stylebox("normal")
		if i.name==sel.name:
		## 设置按钮
			$Setting/SetButton.text = sel.text
			$Setting/SetButton.get_theme_stylebox("normal")["bg_color"]=Color("dc008eff")
			$Setting/SetButton.get_theme_stylebox("normal")["border_color"]=Color("93005bff")
			if ibc["bg_color"]!=Color("dc008e"):sbc["bg_color"]=ebc[4]["bg_color"];sbc["border_color"]=ebc[4]["border_color"]

func ColorChangeBack():
	## 还原未选择的颜色
	for i in keysets:
		var idx = i.get_index()
		var ibc = i.get_theme_stylebox("normal")
		if ibc["bg_color"]==Color("dc008e") and $Setting/SetButton.text!=i.text:
			if idx<8:ibc["bg_color"]=ebc[0]["bg_color"];ibc["border_color"]=ebc[0]["border_color"]
			elif idx>7 and idx<16:ibc["bg_color"]=ebc[1]["bg_color"];ibc["border_color"]=ebc[1]["border_color"]
			elif idx>15 and idx<22:ibc["bg_color"]=ebc[2]["bg_color"];ibc["border_color"]=ebc[2]["border_color"]
			elif idx>21 and idx<40:ibc["bg_color"]=ebc[3]["bg_color"];ibc["border_color"]=ebc[3]["border_color"]
## Global Button
func Clear():
	for i in keysets.size():
		if i < 22:keysets[i].text = counm.split("/")[i]
		else:keysets[i].text = counm.split("/")[i]
func Default():
	for i in keysets.size():
		if i < 22:keysets[i].text = counm.split("/")[i]+"\n"+keyboard.split("/")[i]
		else:keysets[i].text = counm.split("/")[i]
##################################
func HotKeys(file="KeyboardMD.ini"):
	var content = "[Hotkey]\n"
	var slot = $"-Ra2Keys/V1/Flow".get_children()
	for i in slot:
		var space = "				;"
		var keycodes = str(i.editor_description.split("/")[1].to_ascii_buffer().decode_s8(0))
		var key = i.editor_description.split("/")[1]
		if keycodes!="0":
			if i.name=="Options":content+=i.name +"=27"+"					;"+key+"\n"
			elif i.name=="CenterOnRadarEvent":content+=i.name+"=32"+"		;"+key+"\n"
			elif i.name=="Delete":content+=i.name+"=46"+"					;"+key+"\n"
			else:
				if i.name=="Follow":space="					;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name=="ScreenCapture":space="				;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==6:space="				;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==7:space="					;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==13:space="			;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==14:space="			;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==15:space="			;";content+=i.name+"="+keycodes+space+key+"\n"
				elif i.name.length()==22:space="	;";content+=i.name+"="+keycodes+space+key+"\n"
				else:content+=i.name+"="+keycodes+space+key+"\n"
	#print(content)
	if !FileAccess.file_exists("res://KeyboardMD.ini"):
		var File = FileAccess.open(file,FileAccess.WRITE)
		File.store_string(content)
