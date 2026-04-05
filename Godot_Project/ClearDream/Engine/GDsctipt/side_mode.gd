extends GraphEdit

var selNode = []
var copyNode = []
var pos = Vector2.ZERO

## Link Node
func connect_request(from_node, from_port, to_node, to_port):
	self.connect_node(from_node,from_port,to_node,to_port)
	#print(connections)
	for i in connections:
		var a = get_node(str(i.from_node)).get_child(i.from_port)
		var b = get_node(str(i.to_node)).get_child(i.to_port)
		#var output = []
		match b.get_class():
			"HSeparator":print("GG")
		#print(b.get_parent())
		#output.append(a.text)
		#elif b is SpinBox:
			#output.append(str(b.get_parent().name)+str(b.value))
		#print(output)
func disconnect_request(from_node, from_port, to_node, to_port):
	self.disconnect_node(from_node,from_port,to_node,to_port)
func connect_to_empty(from_node,from_port,release_position):
	print("New")
	#clear_connections()

## Select
func node_selected(node):
	selNode.push_back(node)
func node_unselected(node):
	var idx = selNode.find(node)
	if idx!=-1:selNode.remove_at(idx)

## Copy Paste Delete
func cut_request():
	for i in selNode:
		copyNode.push_back(i.duplicate())
	for i in selNode:
		if i!=null:
			i.queue_free()
	selNode.clear()
	#print("Ctrl+X")
func copy_request():
	selNode.clear()
	copyNode.clear()
	for i in selNode:
		copyNode.push_back(i.duplicate())
	#print("Ctrl + C")
func paste_request():
	for i in copyNode:
		add_child(i,true)
	#print("Ctrl + V")
func duplicate_request():
	for i in selNode:
		add_child(i.duplicate(),true)
	#print("Ctrl + D")
func delete_request(nodes):
	for i in nodes:get_node(str(i)).queue_free()
	#print("Delete")

## Mouse RightClick
func popup_request(at_position):
	var rmb = $"../en"
	rmb.show();rmb.position = at_position + Vector2(815,406);pos = rmb.position
	print("RMB")
func en_pressed(index):
	const menu = "Global/AllTyle/Mult/Veteran/Type"
	var node = $"../Base/".get_node(menu.split("/")[index]).duplicate()
	node.position_offset = pos - Vector2i(815,406)
	add_child(node,true)
