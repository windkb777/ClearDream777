#@tool
extends Node

@export_enum("Side Mode","Unit Mode") var Mode = "Side Mode"

var color1 = Color("2939ccff")
var color2 = Color("19247fff")
const bgcolor = Color("121212ff")
const ed = "●"
var mousePos = Vector2.ZERO
const windowOffset = Vector2(815,406)

#func _ready():
	#Nodes("Global")

func _input(event):
	if Input.is_action_just_pressed("R_Click"):
		var panel = $en
		panel.show()
		panel.position=event.position + windowOffset
		mousePos = event.position


func en_pressed(index):
	const node = "res://Engine/-inside-/2DNode/"
	const menu = "global/types/mult/veteran"
	var path = ""
	
	match index:
		0:path = node+menu.split("/")[0]
		1:path = node+menu.split("/")[1]
		2:path = node+menu.split("/")[2]
		3:path = node+menu.split("/")[3]
	var obj = load(path+".tscn").instantiate()
	#add_child(obj);obj.position = mousePos
