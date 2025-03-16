extends Control
class_name ArchFloor

var content
var floor_num : String
var dv : String
var revealed : bool = false

# Two types of rects: Single floor, branching floor

func _ready():
	pass

func set_up_floor(num, label):
	floor_num = num
	content = label
	$Button.text = "%s" % floor_num

func _to_string() -> String:
	if floor_num:
		return str(floor_num) + " " + content
	else:
		return "Not set up yet."


func _on_button_pressed() -> void:
	$Button.text = floor_num + ": " + content
