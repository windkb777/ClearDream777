extends Node

var game_path = OS.get_executable_path()
var Tool = [Ra2md.new(),Bat.new()]
var SmallUIs = {}
var Unit = {}
var ui = 1
var WindowUI = null

#const options = ["res://Engine/-inside-/Confirm.tscn"]
#var subbox = null

func _ready():
	var node = get_parent().get_child(1)
	if node.name=="Color":
		for i in node.get_children():i.show()
	#else:
		#get_parent().get_child(1).show()

##Windows Contral
func DragWindows(event,obj=get_parent()):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		obj.position += Vector2i(event.relative)
func NewWindow(tscn):
	var scene = load(tscn).instantiate()
	get_parent().add_child(scene)
	scene.show()
	#subbox = scene

##func
func 概率():
	var result
	var def = ["默认启动","启默动方"]
	const ars = "Ares方式启动"
	var type = ["A","B"].pick_random()
	#A
	if   type == "A":result = randi_range(0,99)
	#B
	elif type == "B":
		result = randf_range(randi_range(randi()%12,randi()%100),randf_range(randi()%12,randi()%100))
		result = str(result).substr(6,randi_range(1,2))
	match result:
		0:$OptionButton.set_item_text(0,def[0])
		99:$OptionButton.set_item_text(0,def[1]);$OptionButton.set_item_text(1,ars)
	return result
func play_sfx(path):
	var sfx = AudioStreamPlayer.new()
	sfx.connect("finished",sfx.queue_free)
	add_child(sfx)
	sfx.volume_db = randf_range(-12,0)
	sfx.stream = load("res://z.godot_setting/sfx/"+path+".wav")
	sfx.play()
func waitime(time):
	await get_tree().create_timer(time).timeout

##Panel Func
func ImageExport(num):
	var Cameo = [get_parent().get_child(1).get_node("Viewer/info/Cameo/icon"),get_parent().get_child(1).get_node("Viewer/info/AltCameo/icon")]
	var path = "res://Plugin/" + Unit["Cameo"]
	var type = ["_Art.ini","_Rules.ini","icon.png","uico.png","_SpriteSheels.png",".gif"]
	var pic = get_viewport().get_texture().get_image()
	match num:
		0:pic.get_region(Rect2i(Cameo[0].global_position,Vector2i(60,48))).save_png(path+type[2])
		1:pic.get_region(Rect2i(Cameo[1].global_position,Vector2i(60,48))).save_png(path+type[3])
