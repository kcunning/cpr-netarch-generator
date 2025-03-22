extends Node2D

var first : String
var second: String
var floor_num

func set_up_floor(num, cont1, cont2):
	#var first = find_child("FirstContent")
	#first.text = "%da: %s" % [num, cont1]
	#var second = find_child("SecondContent")
	#second.text = "%db: %s" % [num, cont1]
	first = cont1
	second = cont2
	floor_num = num
	$First/FirstContent.text = str(floor_num) + "a"
	$Second/SecondContent.text = str(floor_num) + "b"


func _on_first_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$First/FirstContent.text = floor_num + ": " + first


func _on_second_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$Second/SecondContent.text = floor_num + ": " + second
