@tool
extends Control

@export var Title : String = "测试面板"
@export var Vers : String = "Direct By The Dreamer  26/2/13"
@export_category("面板")
@export var WindowSize : Vector2
@export var minMaxSize : int = 0
@export var TitleOffset : int = 0
@export var ParentNode : Node
@export var TitleColor : Color = Color("151515ff")
@export var BGColor : Color = Color("242424ff")
@export var ButtonPress : Color = Color("4400ccff")
@export var ButtonHold : Color = Color("323232ff")
#@export_group("Buttons")
@export_category("Buttons")
@export var Info : bool = true
@export var UI : bool = true
@export var Code : bool = true
@export var Min : bool = true
@export var Close : bool = true

@export var Custom1 : String = ""
@export var Custom2 : String = ""

var selNode = null

#func _physics_process(_delta):
	#WindowSet()

func _ready():
	WindowSet()

func WindowSet():
	for i in 5:
		if [Info,UI,Code,Min,Close][i]==false:
			$Buttons.get_children()[i].hide()
		else:
			$Buttons.get_children()[i].show()
	if ParentNode!=null:WindowSize = ParentNode.size
	for i in [$Buttons/Custom1,$Buttons/Custom2]:
		i.text = [Custom1,Custom2][i.get_index()-3]
		if i.text.is_empty():i.hide()
		else:i.show()
	##Size Set
	$Title.size = Vector2(WindowSize.x,45) - Vector2(TitleOffset,0)
	$BGTitle.size.x = WindowSize.x
	$BG.size = WindowSize
	$Buttons/Min.custom_minimum_size.x = minMaxSize
	$Buttons/Close.custom_minimum_size.x = minMaxSize
	$Buttons.position=Vector2(WindowSize.x-9-$Buttons.size.x,4)
	$Ver.position=Vector2(WindowSize.x-24,WindowSize.y-12)-$Ver.size
	#get_tree().root.size = WindowSize
	##Text Set
	$Title.text = Title
	$Ver.text = Vers
	##Line 
	LineSet(WindowSize.x,WindowSize.y)
	##Color
	$Title.get_theme_stylebox("panel")["bg_color"] = TitleColor
	$BG.get_theme_stylebox("panel")["bg_color"] = BGColor
	##Button
	#BindButtons()
func LineSet(X,Y,L=0,U=0):
	##Y+2 B-1 X+2 R-1
	const l = 3
	const u = 2
	$bg_line.points[0] = Vector2(U+l,L+l)
	$bg_line.points[1] = Vector2(X-u,U+l)
	$bg_line.points[2] = Vector2(X-u,Y-u)
	$bg_line.points[3] = Vector2(L+l,Y-u)

func MinButton():
	get_parent().set_mode(1)
func CloseButton():
	get_parent().queue_free()
