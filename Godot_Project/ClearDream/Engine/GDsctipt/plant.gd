extends Control

@export var x : int = 3
@export var y : int = 3

func _ready():
	const poly = [Vector2(0,0),Vector2(-30,15),Vector2(-1,30),Vector2(29,15)]
	const cw = poly[1]
	for i in x+y:
		var C = Polygon2D.new();add_child(C,true);C.polygon=poly;C.color=Color.DARK_GREEN
		C.name="1";C.offset=cw * C.name.to_int() - cw
		if i>=x:C.offset+=Vector2(29,15) - x * cw
		#print()




func _process(delta):
	pass
