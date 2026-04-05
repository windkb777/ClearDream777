extends Window

func _ready():
	SetGamePath()
	$Button.Bind()
	$Engine/tv.Bind()
	$Engine/side.Bind()

#func _input(event):
	#Soft.DragWindows(event)

## Ready
func SetGamePath():
	## When Press PlayButton Set The GamePath
	var exe = Soft.game_path.split("/")[Soft.game_path.split("/").size()-1]
	Soft.game_path = Soft.game_path.replace("/%s"%exe,"")
	Soft.game_path = Soft.game_path.replace("godot.windows.opt.tools.64.exe/","")
