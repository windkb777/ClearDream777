@tool
extends Node2D

@export_enum("Crate","WCrate","SilverCrate") var CrateBox = "Crate"
@export var Details = "Goodie Crate"
@export var Buffs = ""

func _ready():
	CrateType()

func CrateType():
	## Type
	for i in $Type.get_children():i.show()
	match CrateBox:
		"Crate":$Type.get_node("sea box").hide();Details="Goodie Crate"
		"WCrate":$Type.get_node("land box").hide();Details="Water Crate"
		"SilverCrate":$Type.get_node("sea box").hide()
	## Buffs
	if Buffs!="":$Buffs.get_node(Buffs).show();$Type.hide()
	

func RandomCratePowerUPs():
	##护甲/火力/金钱/全图/速度/升级/车辆
	##无敌/离子风暴/气体/泰矿/太空舱/隐身/黑暗/爆炸/核弹/汽油弹/小队
	var PowerUPs=[
		powerup("Armor","ARMOR",10,1.5),
		powerup("Firepower","FIREPOWR",10,2.0),
		powerup("HealBase","HEALALL",10),
		powerup("Money","MONEY",20,2000),
		powerup("Reveal","REVEAL",10),
		powerup("Speed","SPEED",10,1.2),
		powerup("Veteran","VETERAN",20,1),
		powerup("Unit","<none>",20,"","no"),
		
		powerup("Invulnerability","ARMOR",0,1.0),
		powerup("IonStorm","<none>"),
		powerup("Gas","<none>",0,100),
		powerup("Tiberium","<none>",0,"","no"),
		powerup("Pod","CLOAK"),
		powerup("Cloak","CLOAK",0,100),
		powerup("Darkness","SHROUDX"),
		powerup("Explosion","<none>",0,500),
		powerup("ICBM","CHEMISLE"),
		powerup("Napalm","<none>",0,600,"no"),
		powerup("Squad","<none>",0,0,"no")]
	var output="[Powerups]\n"
	for i in PowerUPs:output+=i
	return output

func powerup(属性:String,动画:String="<none>",几率:int=0,倍数="",是否支持水里="yes"):
	return 属性+"="+str(几率)+","+动画+","+是否支持水里+","+str(倍数)+"\n"
