# TODO:
# ✅Branching
# ✅Need a way to do a new arch w/o restarting the app
# ✅Branching causes too many floors. Need to move counter head one, and keep track of 
#	floor num seperately.
# ⏹️Figuring out the centering issue
# ⏹️Prettify!
# ⏹️Remove prints and unused code

extends Node2D

var arch_dv : String
var dv_btn_grp : ButtonGroup
var curr_dv_table : Dictionary
var floor_pos_diff : Vector2 = Vector2(0, 100)
var floors_dict : Dictionary = {}
var curr_branches : int = 0
var arch_node
@onready var camera = $Camera2D
var max_y : float

var lobby_table : Dictionary = {
	1: "File DV6",
	2: "Password DV6",
	3: "Password DV8",
	4: "Skunk",
	5: "Wisp",
	6: "Killer"
}

var basic_table : Dictionary = {
	3: "Hellhound",
	4: "Sabertooth",
	5: "Raven x 2",
	6: "Hellhound",
	7: "Wisp",
	8: "Raven",
	9: "Password DV6",
	10: "File DV6",
	11: "Control Node DV6",
	12: "Password DV6",
	13: "Skunk",
	14: "Asp",
	15: "Scorpion",
	16: "Killer, Skunk",
	17: "Wisp x 3",
	18: "Liche"
}

var standard_table : Dictionary = {
	3: "Hellhound x 2",
	4: "Hellhound, Killer",
	5: "Skunk x 2",
	6: "Sabertooth",
	7: "Scorpion",
	8: "Hellhound",
	9: "Password DV8",
	10: "File DV8",
	11: "Control Node DV8",
	12: "Password DV8",
	13: "Asp",
	14: "Killer",
	15: "Liche",
	16: "Asp",
	17: "Raven x 3",
	18: "Liche, Raven"
}

var uncommon_table : Dictionary = {
	3: "Kraken",
	4: "Hellhound, Scorpion",
	5: "Hellhound, Killer",
	6: "Raven x 2",
	7: "Sabertooth",
	8: "Hellhound",
	9: "Password DV10",
	10: "File DV10",
	11: "Control Node DV10",
	12: "Password DV10",
	13: "Killer",
	14: "Liche",
	15: "Dragon",
	16: "Asp, Raven",
	17: "Dragon, Wisp",
	18: "Giant"
}

var advanced_table : Dictionary = {
	3: "Hellhound x 3",
	4: "Asp x 2",
	5: "Hellhound, Liche",
	6: "Wisp",
	7: "Hellhound, Sabertooth",
	8: "Kraken",
	9: "Password DV12",
	10: "File DV12",
	11: "Control Node DV12",
	12: "Password DV12",
	13: "Giant",
	14: "Dragon",
	15: "Killer, Scorpion",
	16: "Kraken",
	17: "Raven, Wisp, Hellhound",
	18: "Dragon x 2"
}

func get_new_floor_key(used_nums):
	# Assumes that we've already set the DV
	while true:
		var n = roll_dice(3, 6)
		if "Control" in curr_dv_table[n] or "File" in curr_dv_table:
			return n
		if not n in used_nums:
			return n

func get_branched_net_floors_dict():
	# How many floors will we have?
	var total_floors = roll_dice(3, 6)
	print("Generating floors: ", total_floors)
	var branched = false
	# The first floor will always be Password DV6
	floors_dict["1"] = ["Password DV6"]
	# The second floor will pull from the lobby
	while true:
		var n = roll_dice(1, 6)
		if lobby_table[n] != "Password DV6":
			floors_dict["2"] = [lobby_table[n]]
			break
	# For every floor, make sure we're getting a new number for the table.
	var used_nums = []
	var filled_floors = 2
	var curr_floor = 3
	
	while filled_floors <= total_floors:
		# Every floor after, check to see if we'll branch
		# If so, stop checking, split bw the two
		var n : int
		if not branched:
			var r = roll_dice(1, 10)
			if r >= 7:
				branched = true
		
		if not branched:
			# Make a single floor
			n = get_new_floor_key(used_nums)
			floors_dict[str(curr_floor)] = [curr_dv_table[n]]
			used_nums.append(n)
			filled_floors += 1
			curr_floor += 1
		elif branched and (total_floors - filled_floors) > 2:
			n = get_new_floor_key(used_nums)
			floors_dict[str(curr_floor)] = [curr_dv_table[n]]
			used_nums.append(n)
			filled_floors += 1
			n = get_new_floor_key(used_nums)
			floors_dict[str(curr_floor)].append(curr_dv_table[n])
			used_nums.append(n)
			filled_floors += 1
			curr_floor += 1
			if total_floors - filled_floors == 2:
				total_floors -= 2
		elif branched and (total_floors - filled_floors) < 2:
			# Finally, if we're down to two floors and an empty level, only do one
			print("Single half floor here...")
			n = get_new_floor_key(used_nums)
			floors_dict[str(curr_floor)] = [curr_dv_table[n]]
			used_nums.append(n)
			filled_floors += 1
			curr_floor += 1
			break

func roll_dice(n, d):
	var s = 0
	for i in n:
		var r = randi_range(1, d)
		s += r
	return s
	
func get_net_floors_dict():
	var floor_num = roll_dice(3, 6)
	var branches = 0
	print("Generating %s floors" % floor_num)
	while true:
		var b = roll_dice(1, 10)
		if b >= 7:
			branches += 1
		else:
			break
	print("We should have %d branches" % branches)
	# Let's get the lobby first...
	var floor_scn = load("res://floor.tscn")
	var br_floor_scn = load("res://branched-floor.tscn")
	var fl = floor_scn.instantiate()
	fl.set_up_floor("1", "Password DV6")
	floors_dict[1] = [fl]
	fl = floor_scn.instantiate()
	var n
	while true:
		n = roll_dice(1, 6)
		if lobby_table[n] != "Password DV6":
			break
	fl.set_up_floor("2", lobby_table[n])
	floors_dict[2] = [fl]
	# Now let's get the rest of the floors!
	var used_nums = []
	for i in floor_num - 1:
		if i == 3:
			print("We should branch here")
			curr_branches = 1
			#break
		while true:
			n = roll_dice(3, 6)
			var val = curr_dv_table[n]
			if val.contains("File") or val.contains("Control"):
				# We want netrunners to get more files or control nodes
				break
			if not n in used_nums:
				used_nums.append(n)
				break
		fl = floor_scn.instantiate()
		fl.set_up_floor(str(i+3), curr_dv_table[n])
		var btn = fl.get_children()[0]
		print(btn.size)
		if curr_branches > 0:
			btn.size.x = 200
		floors_dict[i+1] = [fl]
		
func set_dv(btn):
	print(btn)
	arch_dv = btn.name
	match arch_dv:
		"Basic": curr_dv_table = basic_table
		"Standard": curr_dv_table = standard_table
		"Uncommon": curr_dv_table = uncommon_table
		"Advanced": curr_dv_table = advanced_table
	$DVContainer/GenerateFloors.visible = true

func _ready():
	var btns = get_tree().get_nodes_in_group("dvselect")
	for btn in btns:
		btn.pressed.connect(set_dv.bind(btn))
	max_y = camera.position.y
		
func _on_generate_floors_pressed() -> void:
	get_branched_net_floors_dict()
	print("Current Floors dict:", floors_dict)
	var arch_scn = load("res://branched-floor.tscn")
	arch_node = arch_scn.instantiate()
	print("Setting up with floors dict, ", floors_dict)
	arch_node.title = arch_dv
	arch_node.set_up_arch(floors_dict)
	$".".add_child(arch_node)
	$DVContainer.visible = false
	$BackBtn.visible = true
	arch_node.position = Vector2(500, 0)
	
func _unhandled_input(event: InputEvent) -> void:
	#print(event)
	if event is InputEventMouseButton and event.pressed==true:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.position.y += 20
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and camera.position.y > max_y:
			camera.position.y -= 20


func _on_back_btn_pressed() -> void:
	print("Back button pressed")
	arch_node.queue_free()
	$DVContainer.visible = true
	$BackBtn.visible = false
	
