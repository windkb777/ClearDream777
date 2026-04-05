extends Window

const ra2mdCountry = "美国/韩国/法国/德国/英国/利比亚/伊拉克/古巴/苏俄"
const fourth = "尤里_Yuri/全球防卫组织_GDI/兄弟会_NOD/中立_Civilian/特殊_Mutant"
const flags = "usai/japi/frai/germ/ukin/djbi/arbi/lati/rusi"
const details = {Flag="usai",EN="English",ON="Eng",ZH="英文"}

@onready var List = $Flags/Scroll/list.get_children()
@onready var Edit = $Sides/Slots.get_children()
@onready var Special = $Spec/list/items.get_children()

func _ready():
	OpenAnmi()
func _input(event):
	Soft.DragWindows(event,self)

func OpenAnmi(objs=List+Edit+Special):
	for i in objs:i.hide()
	await Soft.waitime(0.4)
	objs.shuffle();for i in objs:await Soft.waitime(0.02);i.show()

func infos():
	var cmd = Ra2md.new().Split_Type("Country Statistics")+"\n"
	for i in List.size():if List[i].get_child(2).name!="info":cmd+=Slot(List[i].get_child(2).text,true)+"\n"
	print(cmd)
func Slot(Name:String,isMultiplay:bool,SPCS="null/null/null/null"):
	## Suffix Prefix Color Side
	for i in Edit.size():
		if !Edit[i].is_class("Label") and Edit[i].text.contains(Name):
			match Edit[i].text.split("=")[0]:
				"ThirdSide":SPCS = "Soviet/B/DarkRed"
				"GDI":SPCS = "Allied/G/Gold"
				"Nod":SPCS = "Soviet/B/DarkRed"
				"Civilian":SPCS = "CIV/C/Grey"
				"Mutant":SPCS = "JP/J/Grey"
			SPCS += "/"+Edit[i].text.split("=")[0]
	## 根据特殊阵营将 Multiplay 变为 MultiplayPassive
	var ive = "GDI/Nod/Neutral/Special".split("/")
	var mult = "Multiplay="
	for i in ive.size():if Name==ive[i]:mult = "MultiplayPassive="
	#Name2.get_node()
		#print(Name2[i].text)
	## 阵营设置
	var Slots  = [
		"["+Name+"]",
		"UIName=Name:"+Name,
		"Name="+Name,
		"SmartAI=yes",
		mult+str(isMultiplay),
		"Suffix="+SPCS.split("/")[0],
		"Prefix="+SPCS.split("/")[1],
		"Color="+SPCS.split("/")[2],
		"Side="+SPCS.split("/")[3]]
	## 输出单个 Country Slot Label
	var comment = ""
	for i in Slots.size():comment+=Slots[i]+"\n"
	return comment
func Colors():
	const _LightGold = Color(25,255,255)
