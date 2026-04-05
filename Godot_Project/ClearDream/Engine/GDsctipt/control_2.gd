@tool
extends Control

@export var ON : bool


func _process(delta):
	if ON==true:
		using_fileaccess("res://adogicon.shp")
		#Shp_Loader("res://caind01.shp")


func Shp_Loader(path=""):
	#Select_Shp = path
	##加载读取文件
	var loader = FileAccess.get_file_as_bytes(path)
	##读文件的十六进程HEX数据
	var hex = loader.hex_encode()
	var hex_size = hex.length()
	##将HEX分组/分别为2字节一组，8字节一组，16字节一组
	var group2 = []
	var group8 = []
	var group18 = []
	for i in range(0,hex_size,2):var byte2 = hex.substr(i,2);group2.append(byte2)
	for i in range(0,group2.size(),8):var byte8 = group2.slice(i,i+8);group8.append(byte8)
	for i in range(0,hex_size,18):var byte18 = hex.substr(i,18);group18.append(byte18)
	##读取文件头数据
	var Empty = (group8[0][0]+group8[0][1]).hex_to_int()
	var FullWidth = (group8[0][0]+group8[0][2]).hex_to_int()
	var FullHeight = (group8[0][0]+group8[0][4]).hex_to_int()
	var NrOfFrames = (group8[0][7]+group8[0][6]).hex_to_int()
	var _Head = [Empty,FullWidth,FullHeight,NrOfFrames]
	#print(_Head)
	####读取动画帧数据
	for i in range(0,NrOfFrames*3,3):
		####跳过文件头部数据 从第一帧开始
		var num = i+1
		####读取帧画面的Offset_XY和像素宽高
		var FrameX = (group8[i][0]+group8[num][0]).hex_to_int()
		var FrameY = (group8[i][0]+group8[num][2]).hex_to_int()
		var FrameWidth = (group8[i][0]+group8[num][4]).hex_to_int()
		var FrameHeight = (group8[i][0]+group8[num][6]).hex_to_int()
		var _FrameSize = {"num"=num/3+1,"offset"=Vector2(FrameX,FrameY),"size"=Vector2(FrameWidth,FrameHeight)}
		#if i==0:print(_FrameSize)
		####0x08/UINT32LE/Flags  ##0x0C/BYTE[4]/FrameColor  ##0x10/UINT32LE/Reserved  ##0x14/UINT32LE/DataOffset
		#var Flags = (group8[num][0]+group2[num+8]).to_utf32_buffer().decode_u32(1)
		#var FrameColor = (group8[num][0]+group2[num+12]).hex_to_int()
		#var Reserved = (group8[num][0]+group2[num+16]).to_utf32_buffer()
		#var DataOffset = (group8[num][0]+group2[num+20]).to_utf32_buffer().decode_u8(254/num)
		
		var Flags = (group8[i][0]+group8[num][0]).hex_to_int()
		var FrameColor = (group8[i][0]+group8[num][0]).hex_to_int()
		var Reserved = (group8[i][0]+group8[num][0]).hex_to_int()
		var DataOffset = (group8[i][0]+group8[num][0]).hex_to_int()
		var _Spec = [Flags,FrameColor,Reserved,DataOffset]
		#print(_Spec)
		####颜色预读
		#var rgb = (Color(snapped((int(FrameColor[0])/15.0),0.001),snapped((int(FrameColor[1])/15.0),0.001),snapped((int(FrameColor[2])/15.0),0.001))).to_html()
		#print_rich("[color="+str(rgb)+"]■■■■■■[/color]")
		####读取到帧数边界停止/动画帧为帧总数÷2/拿GI举例744帧只用到了371帧(从第0帧开始计算)
		if num/3+1 == NrOfFrames/2:return
		####打印输出

func using_fileaccess(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var empty = file.get_16()
	var full_width = file.get_16()
	var full_height = file.get_16()
	var nr_of_frames = file.get_16()
	print("empty: ",empty," Width: ",full_width," Height: ",full_height," Frames: ",nr_of_frames)
	
	for i in nr_of_frames:
		var frame_x = file.get_16()
		var frame_y = file.get_16()
		var frame_w = file.get_16()
		var frame_h = file.get_16()
		var flags = file.get_32()
		var frame_color_r = file.get_8()
		var frame_color_g = file.get_8()
		var frame_color_b = file.get_8()
		var frame_color_a = file.get_8()
		var _reserved = file.get_32() # Not used
		var data_offset = file.get_32()
		prints("--- Frame %s" % i, data_offset, "x,y,w,h", frame_x, frame_y, frame_w, frame_h,"flags", flags, "rgba", frame_color_r, frame_color_g, frame_color_b, frame_color_a)
		ON=false
