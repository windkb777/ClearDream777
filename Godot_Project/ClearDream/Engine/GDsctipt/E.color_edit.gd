extends Window

var sel = null
var SelColor = null

func _ready():
	#OpenAnmi()
	#inputNums()
	connectButtons()
	ColorPickerSet("Bind")

func _input(event):
	#$"../Window".position = self.position + Vector2i(785,0)
	#Soft.DragWindows(event,self)
	if Input.is_action_just_pressed("L_Click") and event is InputEventMouseButton and sel!=null:
		if !sel.name.contains("use"):
			BlockStyles("MouseClickB",sel)
		else:
			ChangeColor()
			#print("Change Color")

## 启动动画
func OpenAnmi():
	var group = $UI/base.get_children()+$UI/plus.get_children()+$UI/Ares.get_children()+$UI/Used.get_children()+$UI/Slot.get_children()
	group.shuffle()
	for i in group:i.hide()
	await Soft.waitime(0.36)
	for i in group:await Soft.waitime(0.003);i.show();Soft.play_sfx("sel_1")
## Buttons
func connectButtons():
	#$"../Window".position = self.position + Vector2i(785,0)
	$UI/Slot/ColorPicker.connect("color_changed",func(color:Color):SelColor.get_theme_stylebox("normal")["bg_color"] = color)
	for i in 17:
		if i!=0:
			var sel_num = get_node("UI/Used/%s"%i)
			var set_color = get_node("UI/Used/use%s"%i)
			if sel_num!=null:
				sel_num.connect("mouse_entered",func():sel=sel_num)
				sel_num.connect("mouse_exited",func():sel=null)
			if set_color!=null:
				set_color.connect("mouse_entered",func():sel=set_color)
				set_color.connect("mouse_exited",func():sel=null)
#func inputNums():
	#var num = $UI/Slot/count.text.to_int()
	#var slot = [$"../Window/list/text".get_children(),$"../Window/list/colors".get_children()]
	#var disable = Color("787878ff")
	#print(num)
	#for i in 17:
		#if i!=0:
			#slot[0][i].modulate = disable
			#slot[1][i].modulate = disable
			#print(i)
## Press Color Set
func BlockStyles(type,obj):
	if obj.get_theme_stylebox("normal") is not StyleBoxEmpty or type=="null":
		obj.remove_theme_stylebox_override("normal")
	else:
		## Add New Box
		var box=StyleBoxFlat.new()
		obj.add_theme_stylebox_override("normal",box)
		## LightButton
		if type=="ButtonPress":
			box.set_corner_radius_all(1)
			box.bg_color=Color("4400ccff")
		## LightBox
		elif type=="MouseClickB":
			box.border_width_bottom=4
			box.border_color=Color("006319ff")
			box.bg_color=Color("00d33eff")
		## LightBox
		elif type=="ShadowSelect":
			box.border_width_bottom=4
			box.border_color=Color("4c4c4cff")
			box.bg_color=Color("b1b2b3ff")
func ChangeColor():
	var node = $UI/Used.get_node(sel.name.erase(0,3))
	var selmask = $UI/Used/SelMask
	selmask.position = node.position - Vector2(4,4)
	if node.get_theme_stylebox("normal") is StyleBoxEmpty:
		selmask.show();ColorPickerSet("Press")
		BlockStyles("ShadowSelect",node)
	elif node.get_theme_stylebox("normal")["bg_color"]==Color("b1b2b3ff"):
		selmask.hide()
		node.remove_theme_stylebox_override("normal")
	else:
		if selmask.visible:selmask.hide()
		else:selmask.show();ColorPickerSet("Press")
func ColorPickerSet(type,Picker=$UI/Slot/ColorPicker):
	var Sets = Picker.get_popup().get_child(0)
	if type=="Bind":
		Sets.position = Picker.position
		Sets.sampler_visible = false
		Sets.color_modes_visible = false
		Sets.sliders_visible = false
		Sets.hex_visible = false
		Sets.presets_visible = false
		Picker.get_popup().force_native = true
		
	elif type=="Press":
		Picker.get_popup().position = sel.global_position + Vector2(905,130)
		#Sets.scale = Vector2(0.6,0.6)
		Picker.get_popup().show()
		SelColor = sel

#func _process(_delta):
	#calc()

#func calc():
	#var input = $"../VBox/HBox/input".text.split(",")
		##119,143,255
		##185,79%,91%
		#var ra = [119,143,255]
		#var hsv = [remap(ra[0],0,255,0,359),remap(ra[1],0,255,0,100),remap(ra[2],0,255,0,100)]
		#var uphsv = [roundi(hsv[0]+0.4),roundi(hsv[1]+0.4),roundi(hsv[2]+0.4)]
		#var gd = [snappedf(remap(uphsv[0],0,359,0,1),0.001),snappedf(remap(hsv[1],0,100,0,1),0.001),snappedf(remap(uphsv[2],0,100,0,1),0.001)]
	#
		#Color.from_hsv(0.0, 1.0, 1.0, 1.0)
		#Color.from_hsv(0.466, 0.561, 1.0, 1.0)
		##Color.from_hsv().h = 
