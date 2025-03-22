extends Node2D
# The plan here is to take an arch, represented by some comlex
# data structure, and render the arch onto the screen. This assumes
# that branches COULD happen. 

# For now, we'll be limiting the number of possible branches to two,
# because that seems sanest. The rules say it could go higher, but I'm
# just tired, okay? Also, that's as branchy as they get in the example 
# arches

# TODO
# ✅Set up the title, too
# ✅Get the single floors rendering
# ✅Get the double floors rendering
# ✅Hide floors until revealed
# ✅Scroll down to other floors
# ✅Randomly generate a tree...
# ✅Scrolling over a floor reveals it...
# ⏹️Make left click undo a reveal

var arch : Dictionary
var branched : bool = false
var num_floors_filled : int = 0
var top_offset = 60
var title : String

func get_fake_arch():
	# Returns a fake arch for now.
	var dd = {
		1: ["Password DV6"],
		2: ["Password DV8"],
		3: ["Wasp"],
		4: ["Asp", "Wisp"],
		5: ["File DV6"],
		6: ["Control DV8"]
	}
	title = "Fake title for now"
	return dd
	
func move_node(node):
	var mid = get_viewport_rect().size / 2
	#print("Mid: ", mid)
	var box = node.find_child("Shape")
	#print("Node width? ", box.shape.size.x)
	var w = box.shape.size.x
	var h = box.shape.size.y
	node.position = Vector2(mid.x - (w/2), node.position.y + top_offset)
	top_offset += h
	if num_floors_filled == 0:
		var arrow = node.find_child("Arrow")
		arrow.visible = false
	num_floors_filled += 1

func set_up_arch(arch=null):
	print("Set up called with", arch)
	$Title.text = title
	var base = $"."
	var single_tscn = load("res://single_foor.tscn")
	var double_tscn = load("res://double_floor.tscn")
	var half_tscn = load("res://half_floor.tscn")
	
	for num in arch:
		#print(num, ": ", len(arch[num]))
		if not branched and len(arch[num]) <= 1:
			# This is for single floors
			var new_floor = single_tscn.instantiate()
			print("Single floor vals: ", num, " ", arch[num][0])
			new_floor.set_up_floor(num, arch[num][0])
			base.add_child(new_floor)
			move_node(new_floor)
		elif len(arch[num]) > 1:
			branched = true
			var new_floor = double_tscn.instantiate()
			new_floor.set_up_floor(num, arch[num][0], arch[num][1])
			base.add_child(new_floor)
			move_node(new_floor)
		elif branched and len(arch[num]) <= 1:
			#print("Branched floor, one floor")
			var new_floor = half_tscn.instantiate()
			#print("Creating with ", num, arch[num])
			new_floor.set_up_floor(num, arch[num][0])
			base.add_child(new_floor)
			move_node(new_floor)
	
func _ready():
	#arch = get_fake_arch()
	#set_up_arch(arch)
	pass	
	
