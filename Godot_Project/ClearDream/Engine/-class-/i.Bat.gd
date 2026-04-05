class_name Bat
extends Node2D

var bat : String
var bat_file : String
var dll = ["Ares","Phobos","DDraw","Style","Mods"]

##Bat Generated
func Play_Option():
	var cmd = ["@echo off\ncd "+"\""+Soft.game_path+"\\Bin"+"\"",
	Title("\n","Config",""),
	CDCD("cd Config"),
	MoveFiles("Config","..","*."),
	Title("\n","mix",""),
	CDCD("cd.. && cd mix/video"),
	MoveFiles("mix/video","..//.."),
	CDCD("cd.. && cd maps"),
	Move_folder("mmx,yro,rmcache","..//.."),
	MoveFiles("mix/maps","..//.."),
	CDCD("cd.."),
	MoveFiles("mix",".."),
	CDCD("cd.."),
	#CDCD("Mods"),MoveFiles("*",".."),CDCD("cd.."),
	#CDCD("Styles"),MoveFiles("*",".."),CDCD("cd.."),
	Move_folder("Ares,Config,mix,Mods,Style,DDraw,Phobos","hide"),
	Title("\n","Dll Expand",""),
	expandDll(),
	color16bit("Play"),
	Syringe_Play()]
	var command = ""
	for i in cmd:command+=i;command+="\n"
	Save_and_Start(command,"Play")
	print(command)
func Debug_Option():
	var cmd = [":: Write By 67 \n:: 该Bat仅供学习与交流，禁止用于商业违法行为 ","@echo off"+"\ncd "+"\""+Soft.game_path+"/Bin"+"\"",
	Title("\n","expandDll",""),
	MoveDll("Ares","Ares"),
	MoveDll("Phobos","Phobos"),
	MoveDll("DDraw","DDraw"),
	Move_folder("Shaders","DDraw"),
	Title("\n","Config",""),
	ReturnFiles("Config","Config","*."),
	Title("\n","mix",""),
	ReturnFiles("mix/video","mix/video"),
	ReturnFiles("mix/maps","mix/maps"),
	ReturnFiles("mix","mix"),
	Move_folder("mmx,yro,rmcache","mix/maps"),
	Title("\n","hide The ",""),
	Move_folder("Ares,Phobos,DDraw,Config,mix,Style,Mods","show"),
	color16bit("Debug"),
	Title("\n","Clear Cache",""),
	ClearCache()]
	var command = ""
	for i in cmd:command+=i;command+="\n"
	Save_and_Start(command,"Debug")
	#print(command)

##File Contral
func Title(front,names,back):
	var cmd = front+":: "+names+" Folder ::"+back
	return cmd
func MoveFiles(names,Path_to,type="*"):
	if Path_to=="..//..":Path_to=".."+"\\"+".."
	var files = get_parent().get_node("file").Read(names)[1]
	var cmd = "for %%i in "+"("+files+")"+" do move "+type+"%%i "+Path_to
	return cmd
func ReturnFiles(names,Path_to,type="*"):
	var files = get_tree().get_first_node_in_group(names).text
	var cmd = "for %%i in "+"("+files+")"+" do move "+type+"%%i "+Path_to
	return cmd
func Move_folder(folders,path):
	if path=="..//..":path=".."+"\\"+".."
	var cmd = "for %%i in ("+folders+") do move %%i "+path
	if path=="hide":cmd="for %%i in ("+folders+") do attrib +h %%i"
	if path=="show":cmd="for %%i in ("+folders+") do attrib -h %%i"
	return cmd
func ClearCache():
	var cmd = "del syringe.log"
	return cmd
func MoveDll(file,Path_to,type="*"):
	var files = Soft.get_node("file/%s"%file).editor_description
	var cmd =  "for %%i in "+"("+files+")"+" do move "+type+"%%i "+ Path_to
	return cmd
func expandDll():
	var cmd = ""
	for i in dll.size():
		if dll.has(dll[i]):
			if i!=4:cmd+="cd "+str(dll[i])+"\n"+MoveDll(dll[i],"..")+"\ncd.. && "
			else:cmd+="cd "+str(dll[i])+"\n"+MoveDll(dll[i],"..")
			if MoveDll(dll[i],"..","").contains("Shaders"):
				cmd+="cd "+str(dll[i])+"\n"+MoveDll(dll[i],"..","")+"\n"
				cmd+="for %%i in (Shaders) do move %%i .."
	return cmd

func Syringe_Play():
	var start = ""
	if Soft.windowed==true:
		if !dll.has("Ares"):start = "\n::Start::\nRa2md.exe -win"
		if !dll.has("DDraw"):"\n::Start::\ncd Bin\n\"Ra2md.exe -win"
		if dll.has("Ares"):start = "\n::Ares Start::\ncd..\nSyringe \"gamemd.exe\" %* "
	return start

func Windowed(type):
	##DDraw 窗口化设置
	var path_a = Soft.game_path+"/Bin/DDraw/ddraw.ini"
	var path_b = Soft.game_path+"/Bin/ddraw.ini"
	if FileAccess.file_exists(path_a):
		var ddraw = FileAccess.open(path_a,FileAccess.READ_WRITE)
		ddraw.seek(513)
		ddraw.store_string("windowed=%s"%type)
		#print("ddraw 在文件夹内")
	elif FileAccess.file_exists(path_b):
		var ddraw = FileAccess.open(path_b,FileAccess.READ_WRITE)
		ddraw.seek(513)
		ddraw.store_string("windowed=%s"%type)
		#print("ddraw 在游戏根目录")
	##窗口化设置 ares

func CDCD(dir):
	var cmd = ""
	cmd = dir
	match dir:
		"back":cmd = "cd.."
		"last":cmd = "cd.."+"\\"+".."
	return cmd

func CD():pass

##Bat File
func Save_and_Start(content,bats):
	#var path=Soft.game_path.replace("BetterUI-ClearDream.exe","")
	bat_file = Soft.game_path+"/"+bats+".bat"
	get_parent().get_parent().get_node("BetterUI-Tools/Label").text = Soft.game_path
	#print(bat_file)
	#bat_file = bats+".bat"
	##外置cmd目录
	if !FileAccess.file_exists(bat_file):
		var file = FileAccess.open(bat_file,FileAccess.WRITE)
		file.store_string(content)
		#print(")¿(")
	##本地cmd目录
	OS.shell_open(bat_file)
	DelBat(bats)
	#print("到件找启动文 已")
func color16bit(names):
	##add 16 bit Color 
	var cmd=""
	var reg=["reg "," \"HKCU\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Layers\" /v \"",
	"\\Bin\\Ra2md.exe\" ","/t REG_SZ /d \"~ 16BITCOLOR\" ","/f"]
	if names=="Play":cmd+="reg add"+reg[1]+Soft.game_path+reg[2]+reg[3]+reg[4]
	elif names=="Debug":cmd+="reg delete"+reg[1]+Soft.game_path+reg[2]+reg[4]
	return cmd
func DelBat(bats):
	await Soft.waitime(1.2)
	if Soft.batWrite==false:
		OS.execute("CMD.exe",["/C","cd %s"%"\""+Soft.game_path+"\""+" && "+"del "+bats+".bat"])
	OS.execute("CMD.exe",["/C","cd %s"%"\""+Soft.game_path+"\""+" && "+"taskkill /F /IM cmd.exe"])

##Buttons
func title_Button(event,node):
	if event is InputEventMouseButton and Input.is_action_just_pressed("L_Click"):
		match node.name:
			"Paint":$Color.position = $Panel/Title/Paint.position+Vector2(-90,30)+Vector2(812,403);$Color.popup()
			"Close":get_tree().quit()
