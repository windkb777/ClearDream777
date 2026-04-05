extends Node

@onready var art_code = $Code/Art/CodeEdit
@onready var rules_code = $Code/Rules/CodeEdit
@onready var SeqGroup = $"Viewer/[Block]"
@onready var gif = $Viewer/GIF/Mask/Sprite

var SeqLine:int
var NodeNums = {}

var Sel = []

#const cn = "生命值/经验值/威胁值/视野_速度/造价_售价/大小_物理/建造顺序/IFVMode"
##常驻[Sequence]动画[Block]共有18种
##分别为"Ready;Guard;Deploy;Walk;Idle;Die;Prone;Crawl;Hover;Tumble;Panice;Paradrop;Cheer;Fire;Up;Down;Fly;AirDeath"
##其中"Idle/Die/Deploy/Fire/AirDeath"有多重变体
##"Idle"及"Die"后缀+动画序号1,2,3....
##"Deploy"的变体则是"Deploy;Undeploy;Deployed;DeployedFire四种
##"Fire"的变体则为"FireUp;FireProne;FireFly"三种
##"AirDeath"是"AirDeathStart;AirDeathFalling;AirDeathFinish"

func _ready():
	var root = get_tree().root
	root.size = Vector2(1762,1065)
	root.position = Vector2(1200,300)
	BindButtons()
	#CodeRules()

func _input(_event):
	View()

func _physics_process(_delta):
	CodeArt()

func CodeRules():
	##获取rules_code最大行数
	##排除使用";"注释的代码
	##将每行代码中的变量提取出来，并且区分
	##从变量中删除UIName的前缀"Name="
	var ranges = rules_code.get_line_count()
	var Attrib = {}
	for i in ranges:
		var line = rules_code.get_line(i)
		if line.contains("=") and !line.contains(";"):Attrib.get_or_add(line.split("=")[0],line.split("=")[1])
	Attrib.UIName = Attrib.UIName.erase(0,5)
	print(Attrib.keys(),"\n\n",Attrib.values())
func CodeArt():
	##获取art_code最大行数
	##获取[...Sequence]所在的行数
	##获取[...Seq]之后的代码 使用"="左边的变量 排除使用";"注释的代码
	var ranges = art_code.get_line_count()
	var code = []
	##编写代码时对[Block]进行删减
	for i in ranges:
		var line = art_code.get_line(i)
		if line.contains("Sequence]"):SeqLine = i
		if line.contains("=") and !line.contains(";") and SeqLine!=0 and i>SeqLine:add_Block("Block",line);code.append(line.split("=")[0])
	DelNode(SeqGroup.get_children(),code)

##Mode
func loadCSV(path):
	## CSV文件读取
	var file = FileAccess.open(path,FileAccess.READ)
	## 获取表格内容
	var content = file.get_csv_line()
	## 获取首行信息，ID,Name,type等类型信息
	var title = content
	## 输出表格内容到数组
	var csv = []
	while not file.eof_reached():
		## 获取每行内容
		content = file.get_csv_line()
		var obj = {}
		## 循环当前行的信息，输出到字典里
		for i in content.size():
			obj[title[i]] = content[i]
		csv.push_back(obj)
	## 移除最后一行空内容
	csv.remove_at(csv.size()-1)
	return csv
func BindButtons():
	var button=[$Mode/sort/units,$Mode/sort/audio,$Mode/sort/pow,$Mode/sort/view,$Mode/sort/code]
	var panel =[$Panel_Units,$Panel_Audio,$Panel_Power,$Viewer,$Code]
	var Export = [$Code/Art/Button,$Code/Rules/Button]
	## Visible Panel
	for i in button:i.connect("pressed",WindowOpacity.bind(i,panel))
	## Write ini
	for e in Export:e.connect("pressed",WriteFile.bind(e.get_parent()))
	## Cameo
	var cameo = [$Viewer/info/Cameo/icon,$Viewer/info/AltCameo/icon]
	for c in cameo:
		c.connect("gui_input",Press)
		c.connect("mouse_entered",func():Soft.nodes.Icon=c)
		c.connect("mouse_exited",func():Soft.nodes.Icon=null)
	#var unitsSprite = $Panel_Units/Infantry
	#const limit = Rect2(48,336,20,500)

func Press(_event=InputEvent):
	if Input.is_action_just_pressed("L_Click"):
		match Soft.nodes.Icon.get_parent().name:
			"Cameo":Soft.IconExport(0)
			"AltCameo":Soft.IconExport(1)

func WriteFile(type):
	if type.name=="Art":print("Write Art ini")
	elif type.name=="Rules":print("Exporting Rules Files......")

func WindowOpacity(pressButton,panel):
	for i in panel.size():
		if panel[i].name.contains(pressButton.text):
			if !panel[i].visible:panel[i].show()
			else:panel[i].hide()
##编辑ArtCode的[Block]
##选择[Sequence]动画 并进行编辑或预览
func View():
	if Input.is_action_just_pressed("L_Click"):
		var mpos = get_child(1).get_local_mouse_position()
		var upos = [$Panel_Units.get_rect().position,$Panel_Units.get_rect().size]
		if mpos.x>upos[0].x and mpos.x<upos[1].x and mpos.y>upos[0].y and mpos.y<upos[1].y:
			SelectCameo()
		if !Sel.is_empty():
			var a = Sel[1].split(",")[0].to_int()
			var b = Sel[1].split(",")[1].to_int()
			NodeNums.set("a",a)
			NodeNums.set("c",a+b)
			gif.frame = a;gif.play()
			#if gif.frame==NodeNums.c:gif.frame=NodeNums.a
func SelectCameo():
	var pos = $Panel_Units.get_local_mouse_position()
	var dir = ceil(pos / Vector2(60,48) - Vector2(0.3,1)) - Vector2(1,1)
	var select = $Panel_Units/Select
	#var CodeEdits = [$Code/Art/CodeEdit,$Code/Rules/CodeEdit]
	var Cameo = [$Viewer/info/Cameo/icon,$Viewer/info/AltCameo/icon]
	var title = [$Viewer/info/Cameo/title,$Viewer/info/AltCameo/title,$Viewer/info/type]
	const unit_name_path = "res://Plugin/单位兵种译名表.csv"
	const UnitPath = "res://image/Units/"
	const icon = "icon/uico"
	##Units Sprite Selecter Limit 
	if pos.x > 20 and pos.x < 500 and pos.y > 48 and pos.y < 336:
		select.frame_coords = dir
		select.position = (dir*Vector2(60,48))+Vector2(20,48)
	##Read Units Detal Infomation
	var csv = loadCSV(unit_name_path)
	for i in csv:
		var grid = i["x,y"]
		var sel = str(select.frame_coords.x)+","+str(select.frame_coords.y)
		var cameoPath = UnitPath + i["Cameo"]
		if sel == grid:
			gif.sprite_frames = load(cameoPath + ".gif")
			title[2].text = title[2].text.format({"Num":i["Frames"]})
			title[0].text = i["Cameo"]+icon.split("/")[0];title[1].text = i["Cameo"]+icon.split("/")[1]
			Cameo[0].texture.region = Rect2(select.frame_coords.x * 60,select.frame_coords.y * 48,60,48)
			Cameo[1].texture.region = Cameo[0].texture.region
			Soft.Unit = i
	var info = $"Viewer/[attrib]/value"
	#const Setting = "Strength/Points/ThreatPosed/Sight/Speed/Cost/Soylent/Size/PhysicalSize/TechLevel/IFVMode"
	#"info.text".contains("Strength")
	## Load Units Files
	#for i in 6:
		#var hasFile=FileAccess.file_exists(path+type[i])
		### Not Has File
		#if !hasFile and i==5:
			#for a in CodeEdits:a.text = " \n\n"
			#print(Unit["单位名"]," 文件缺失")
		### Find File
		#elif hasFile:
			#var artCode = FileAccess.open(path+type[0],FileAccess.READ)
			##var RulesCode = FileAccess.open(path+type[1],FileAccess.READ)
			##print(artCode.get_as_text())
			##CodeEdits[0].text = artCode;CodeEdits[1].text = RulesCode
			##print(Unit["单位名"]+" "+type[i]," 找到文件")


func add_Block(type,linecode=null):
	##添加[Block]
	##-确保[CodeArt]的代码优先级为最高
	##-要是[CodeArt]里面没有而[动画类型]里有这个Block，则会删除没有的Block
	####新代码区块为"="左边的变量
	var NewCode = linecode.split("=")[0]
	if type=="Block":
		##要是[动画类型]里面没有这个Block，则新建一个
		if SeqGroup.get_node_or_null(NewCode) == null:
			var Block = Label.new()
			const themes = "res://theme/text_theme_a.tres"
			SeqGroup.add_child(Block)
			#print("add: ",NewCode)
			Block.name = NewCode ; Block.text = Block.name
			Block.custom_minimum_size = Vector2(100,30)
			Block.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			Block.vertical_alignment = HORIZONTAL_ALIGNMENT_CENTER
			Block.theme = load(themes)
			Block.mouse_filter = Control.MOUSE_FILTER_STOP
			Block.connect("mouse_entered",func():Sel.append(linecode.split("=")[0]);Sel.append(linecode.split("=")[1]))
			Block.connect("mouse_exited",func():Sel.clear())
			##根据变量，改变动画顺序并且标上序号，添加切换按钮
			if "Idle/Die/Deploy/Fire/AirDeath".contains(NewCode):
				#NodeNums.set(Block.name,1)#print(NodeNums)
				for page in 2:Block.add_child(Button.new())
				for obj in Block.get_children():
					if obj.get_index()==0:obj.name="L";obj.text="<";obj.position=Vector2(2,-3);obj.connect("pressed",BlockChange.bind("sub",Block))
					else:obj.name="R";obj.text=">";obj.position=Vector2(75,-3);obj.connect("pressed",BlockChange.bind("add",Block))
					obj.flat=true;obj.theme=load(themes);obj.size=Vector2(30,44);obj.scale=Vector2.ONE * 0.8
				###Print
				#if NodeNums.find_key(NewCode)!=null:print(NodeNums.find_key(NewCode))
	elif type=="Dict":
		var Attrib = {}
		Attrib.get_or_add(NewCode,linecode.split("=")[1])
func DelNode(blocks,code):
	##筛选出[Block]里面多余的Node,并且删除多余的节点
	var diff = []
	for a in blocks:if a.name not in code:diff.append(a)
	for i in diff:i.queue_free()#print("Del: ",i.name);i.queue_free()
func BlockChange(type,Block):
	match type:
		"add":NodeNums[Block.name]+=1
		"sub":NodeNums[Block.name]-=1
	Block.text = Block.name + str(NodeNums[Block.name])
