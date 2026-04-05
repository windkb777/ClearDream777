@tool
extends Panel

@export_enum("Base","Side") var Size = 0
@export_enum("BuildTime","GlobalSet","AddSpec","AddUpgrade") var UI = -1
var objected = null
var code : String = ""

func _ready():
	#$Confirm.connect("pressed",Press)
	$Close.connect("pressed",Quit)
	$side/option.connect("item_selected",option_selected)
	
func StateChange(type,obj):
	var states = $info.get_children()
	for i in states:i.hide()
	objected=obj
	if type=="sc":
		states[8].show();states[8].get_child(1).get_popup().max_size.y = 320
	if type=="tm":
		states[9].show();states[9].get_child(1).get_popup().max_size.y = 320
	if type=="yx":
		states[10].show()
	if type=="lv":
		states[11].show()
	if type=="logic":
		for i in 8:
			if obj.get_index()==2:size.y=220;$Confirm.position.y=175;$Close.position.y=175
			states[obj.get_index()].show()
			return
#func State(type):
	#const types = "BuildTime/GlobalSet/AddSpec/AddUpgrade"
	#for i in types.split("/").size():if types.split("/")[i]==type:option_selected(i)

#func Press():
	#var output = []
	#for i in $info.get_children():
		#if i.visible:
			#if i.get_class()=="Control":output+=i.get_children()
			#if i.get_class()=="CheckButton":output.append(i)
	#for i in output:
		#if i is LineEdit:
			#if i.name=="Max":objected.text = "需求队伍\n%s只"%i.text
			#if i.name=="Priority":objected.text = "优先级\n%s"%i.text
			#if i.name=="TechLevel":objected.text = "科技等级\n%s"%i.text
			#print(i.name,"=",i.text,"dd ",objected.text)
		#if i is CheckButton:
			#if i.is_pressed():print(i.name,"=","yes")
			#else:print(i.name,"=","no")
		#if i is OptionButton:
			#if i.name=="attack":
				#match i.text:
					#"无视攻击":print("Suicide=yes")
					#"反击一次":print("Annoyance=yes")
					#"追击摧毁":print("Suicide=no")
					#"追到家里打":print("Aggressive=no\nSuicide=no")
			#if i.name=="type":
				#match i.text:
					#"战斗部队":print("IsBaseDefense=no")
					#"防御部队":print("IsBaseDefense=yes")
					#"运输部队":print("UseTransportOrigin=yes")
					#"增援部队":print("Reinforce=yes")
					#"传送部队":print("OnTransOnly=yes")
					#"空降部队":print("Droppod=yes")
			#if i.name=="mind":
				#match i.text:
					#"自动":print("MindControlDecision=0")
					#"投敌":print("MindControlDecision=1")
					#"回收":print("MindControlDecision=2")
					#"发电":print("MindControlDecision=3")
					#"寻敌":print("MindControlDecision=4")
					#"发呆":print("MindControlDecision=5")
	#Quit()

func _process(delta):
	match Size:
		0:size = Vector2(270,210)
		1:size = Vector2(400,320)
	$Confirm.position=Vector2(size.x-145,size.y-50)
	$Close.position=Vector2($Confirm.position.x+66,$Confirm.position.y)


func Quit():
	queue_free()
	#get_tree().quit()

func option_selected(index):
	if UI!=-1:
		Display(index)
		CalcCode(index)
func Display(idx):
	$side.show()
	for i in $side.get_children():i.hide()
	if idx<2:
		for i in [5,16,27,38,49]:$side/slots.get_child(i).button_pressed=true
		for i in 4:$side.get_child(i).show()
		for i in $side/slots.get_children():
			if i.is_pressed():
				if i.get_index() < 12:
					print(i.get_index())
	elif idx>1:for i in [0,1,4]:$side.get_child(i).show()
func CalcCode(idx):
	$side/tips.text="数值越小指示器就越靠左！"
	match idx+1:
		1:$side/infos.text="建筑生产：\n防御设施：\n单位出兵：\n车船载具：\n飞行研发："
		2:$side/infos.text="物品花费：\n伤害火力：\n攻击速度：\n护甲防御：\n移动速度："
