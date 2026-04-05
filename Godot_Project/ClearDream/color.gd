extends Panel


@onready var node = [$"../SideColor", $"../hue", $"../color_1", $"../color_2",$"../input/d_hsv", $"../input/d_rgb", $"../input/r_hsv", $"../input/r_rgb",$"../pal".get_children()]
@onready var Sides = {pal=node[0].get_children(),res=[],colorPos={}}

func _ready():
	node[1].connect("color_changed",PaintSideColors)
	$"../add".connect("pressed",colorslot)
	ReadPicData()

#region DrawPic
func ReadPicData(pic=load("res://recolor.png")):
	var img = {num=pic.get_image().get_data().size(),size=pic.get_image().get_size(),colors=pic.get_image().get_data(),data=[]}
	for i in range(0,img.num,3):img.data.append(img.colors.slice(i,i+3))
	DrawPic(Vector2(0,0),img)
func DrawPic(offset:Vector2,datas:Dictionary):
	for y in datas.size.y:
		for x in datas.size.x:
			var numOfPixels = x+y*(datas.size.x)
			var numOfColor = Color(datas.data[numOfPixels][0]/255.0,datas.data[numOfPixels][1]/255.0,datas.data[numOfPixels][2]/255.0)
			## 对比像素颜色 与 Pal颜色的差异 颜色接近不大于阈值 就设置为Pal的颜色
			if numOfColor!=Color.BLACK:
				for i in 16:
					if is_color_similar(numOfColor,Sides.pal[i].color,0.16):
						Sides.res.append_array([[i,numOfPixels]])
				connect("draw",func():draw_rect(Rect2(offset.x+x,offset.y+y,1,1),numOfColor))
			
		for i in 16:Sides.colorPos.set("pal_%s"%i,[])
		## 优化像素颜色位置
		for i in 16:for p in Sides.res.size():if Sides.res[p][0]==i:Sides.colorPos["pal_%s"%i].append(Sides.res[p][1])
func is_color_similar(c1:Color,c2:Color,threshold:float=0.1)->bool:
	# 计算 RGB 空间距离
	var dr = c1.r - c2.r
	var dg = c1.g - c2.g
	var db = c1.b - c2.b
	var dist = sqrt(dr*dr + dg*dg + db*db)
	return dist < threshold
func PaintSideColors(color):
	## 色盘着色
	const sub = "0,16,32,44,60,76,88,104,120,132,148,164,176,192,208,220"
	var n = []
	node[2].color = color;node[3].color = node[2].color
	## Color Text
	node[6].text = str(int(color.h*255))+","+str(int(color.s*255))+","+str(int(color.v*255))
	node[7].text = str(int(color.r*255))+","+str(int(color.g*255))+","+str(int(color.b*255))
	node[4].text = str(int(color.h*359))+","+str(int(color.s*100))+","+str(int(color.v*100))
	node[5].text = str(snappedf(color.r,0.001))+","+str(snappedf(color.g,0.001))+","+str(snappedf(color.b,0.001))
	for i in sub.split(",").size():n.append(sub.split(",")[i].to_int())
	for i in Sides.pal.size():Sides.pal[i].color = color.from_rgba8(int((color*255)[0])-n[i],int((color*255)[1])-n[i],int((color*255)[2]-n[i]),255)
	## 设置
	if Input.is_anything_pressed():
		for i in 16:
			for a in Sides.colorPos["pal_%s"%i].size():
				var pixelNum = Sides.colorPos["pal_%s"%i][a]
				var pos = Vector2(pixelNum-((pixelNum / 320)*320),pixelNum / 320)
				connect("draw",func():draw_rect(Rect2(pos.x,pos.y,1,1),Sides.pal[i].color))
		#queue_redraw()
func colorslot():
	for i in node[8].size():
		#if node[8][i].get_theme_stylebox("normal","StyleBoxFlat").bg_color==Color.WHITE:#Color(0,0,0,0.6):
			#print(node[8][0].get_theme_stylebox("normal","StyleBoxFlat").bg_color)
			print($"../pal/color1".get_theme_stylebox("normal","StyleBoxFlat").bg_color)
			return
			#var box = StyleBoxFlat.new();box.set_corner_radius_all(4);box.bg_color=node[2].color
			#node[8][i].add_theme_stylebox_override("normal",box)
		#else:
			#print(i,"White")
			#var box = StyleBoxFlat.new();box.set_corner_radius_all(4);box.bg_color=node[2].color
			#node[8][i+1].add_theme_stylebox_override("normal",box)
		#return
#endregion
