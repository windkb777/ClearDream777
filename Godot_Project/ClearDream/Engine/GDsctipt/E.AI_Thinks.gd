extends Node

const body = "特定建筑/任意物体/任何建筑/可进驻物体/科技建筑/发电厂/防御设施/矿场/步兵/车辆/工厂/超级武器"

const ctrl = "攻击/移动/集合/分散/撤退/保护/防御/超时空/铁幕"

const order = "重复第x行/跳转到x行/执行第x行/任务执行成功/"

const PosA = [
	"64/245/467/690", ##Y=64
	"64/400/956", ##Y=470
	[Vector2(53,786),Vector2(956,774)]
]

func OpenAnmi():
	print("anmie")

func _ready():
	get_tree().root.size = $Board.WindowSize
	get_tree().root.position = Vector2(0,0)
	ConnectButtons()

func ConnectButtons():
	const gp = "1_Teams/2_Targets/3_Trigger/DetailA/DetailB/"
	var en = "/v/list"
	var outputItem = []
	for i in 5:
		if i>2:en = "/v"
		var g = gp.split("/")[i] + en
		var list = get_node(g).get_children()
		outputItem+=list
	for i in get_children():
		if i.has_node("add"):i.get_node("add").connect("pressed",Buttons.bind("Add",i))
		if i.has_node("id"):i.get_node("id").connect("pressed",Buttons.bind("ID",i))
	for i in outputItem:
		if i.name.contains("team"):i.connect("pressed",Buttons.bind("team",i))
		elif i.name.contains("target"):i.connect("pressed",Buttons.bind("target",i))
		elif i.name.contains("trigger"):for u in 6:i.get_child(u).connect("pressed",Buttons.bind("trigger",i))
		elif i.name.contains("task"):i.connect("pressed",Buttons.bind("task",i))
		elif i.name.contains("logic"):i.connect("pressed",Buttons.bind("logic",i))
		elif i.name.contains("sc"):i.connect("pressed",Buttons.bind("sc",i))
		elif i.name.contains("tm"):i.connect("pressed",Buttons.bind("tm",i))
		elif i.name.contains("yx"):i.connect("pressed",Buttons.bind("yx",i))
		elif i.name.contains("lv"):i.connect("pressed",Buttons.bind("lv",i))

func Buttons(type,i):
	var section = load("res://Engine/-inside-/Confirm.tscn").instantiate()
	section.position = i.global_position - Vector2(86,220)
	get_parent().add_child(section)
	section.StateChange(type,i)
	section.show()
