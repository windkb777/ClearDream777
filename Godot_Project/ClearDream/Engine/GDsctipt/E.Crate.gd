extends Window


const sp =  "\n"



func _ready():
	show()
	#BindButtons($Box)
	#BindButtons($"Crate|Sound")
	print(
		#Title("Crate rules"),
		#Rules($"Crate")+sp,
		#Title("Audio / Visual rules"),
		#AudioVisual($"Crate|Sound")+sp,
		#Title("Multiplayer Dialog Settings"),
		
		#Title("Overlays","A"),
		#Title("Overlay Object List","C"),
		
		#Title("Overlay Objects","B"),
		#OverlaysObjects("CRATE","Goodie Crate","92,92,92",true,true,true,"Clear",false)+sp,
		#OverlaysObjects("WCRATE","Water Crate","92,92,92",true,true,true,"Water",false)
		###RandomCratePowerUPs(),
	)	

func _input(event):
	Soft.DragWindows(event,self)

func BindButtons(object):
	for i in object.get_children():
		if i is not Node2D:i.connect("pressed",Pressed.bind(i))

func Pressed(node):
	if node.icon!=null:
		if node.button_pressed:node.icon.region.position.y=18
		else:node.icon.region.position.y=0
	if node.name.contains("|"):
		var aud = node.name.split("|")[1]
		Soft.play_sfx("Unit_SoundPack/%s"%aud)

#### :: attribute :: ####
func Rules(node):
	var cmd = ""
	var rules=node.get_children()
	for i in rules.size():
		var slot = rules[i]
		if slot is Node2D:cmd+=Soft.Enc.Title(slot.name)+"\n"
		if slot is LineEdit or slot is Label:cmd+=Soft.Enc.eco(slot.name,slot.text)+"\n"
	return cmd
func AudioVisual(node):
	var cmd = ""
	var aud = node.get_children()
	for i in aud:
		var a1=node.name.split("|")[0]
		var a = a1+i.name+node.name.split("|")[1]
		if i is Node2D:cmd+=i.name+"\n"
		if i is not Node2D:cmd+=a+"="+a1+i.text+"\n"
	return cmd

func OverlaysObjects(Name:String,NameDetail:String,RadarColor,isCrate:bool,isTrigger:bool,RadarInvisible:bool,Land,DrawFlat:bool):
	##Tiberium/Crate/CrateTrigger/RadarInvisible/Explodes/LegalTarget/ChainReaction
	##RadarColor/Land(Clear/Water)/DrawFlat
	##是否为泰矿/为宝箱/为触发/雷达可见/是否会爆炸/是否为合法攻击对象/爆炸影响周围单元格
	##雷达颜色/陆地/平滑着色
	var content = "["+Name+"]"+"\nName="+NameDetail+"\nRadarColor="+RadarColor+"\nLand="+Land
	if isCrate:content+="\nCrate=yes"
	else:content+="\nCrate=no"
	if isTrigger:content+="\nCrateTrigger=yes"
	else:content+="\nCrateTrigger=no"
	if RadarInvisible:content+="\nRadarInvisible=yes"
	else:content+="\nRadarInvisible=no"
	if DrawFlat:content+="\nDrawFlat=true"
	else:content+="\nDrawFlat=false\n"
	
	return content

func MultPlayDialogSettings():
	pass

##; *** Overlay Object List ***
##[OverlayTypes]
##182=CRATE
##246=WCRATE
