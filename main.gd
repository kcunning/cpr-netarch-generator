# TODO:
# ⏹️Branching
# ⏹️Need a way to do a new arch w/o restarting the app

extends Node2D

var arch_dv : String
var dv_btn_grp : ButtonGroup
var curr_dv_table : Dictionary
var floor_pos_diff : Vector2 = Vector2(0, 100)
var floors_cont : VBoxContainer
var floors_dict : Dictionary = {}

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

func roll_dice(n, d):
	var s = 0
	for i in n:
		var r = randi_range(1, d)
		s += r
	return s
	
func get_net_floors_dict():
	var floor_num = roll_dice(3, 6)
	print("Generating %s floors" % floor_num)
	# Let's get the lobby first...
	var floor_scn = load("res://floor.tscn")
	var fl = floor_scn.instantiate()
	fl.set_up_floor("1", "Password DV6")
	floors_dict[1] = [fl]
	floors_cont.add_child(fl)
	fl = floor_scn.instantiate()
	var n
	while true:
		n = roll_dice(1, 6)
		if lobby_table[n] != "Password DV6":
			break
	fl.set_up_floor("2", lobby_table[n])
	floors_dict[2] = [fl]
	floors_cont.add_child(fl)
	# Now let's get the rest of the floors!
	var used_nums = []
	for i in floor_num - 1:
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
		floors_dict[i+1] = [fl]
		floors_cont.add_child(fl)

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
	floors_cont = $NetArch/Floors
	var btns = get_tree().get_nodes_in_group("dvselect")
	for btn in btns:
		btn.pressed.connect(set_dv.bind(btn))
		

func _on_generate_floors_pressed() -> void:
	print("Generating floors...")
	$DVContainer.queue_free()
	get_net_floors_dict()
