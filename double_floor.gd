extends Node2D

var first : String
var second: String
var floor_num

func set_up_floor(num, cont1, cont2):
	first = cont1
	second = cont2
	floor_num = num
	$First/FirstContent.text = str(floor_num) + "a"
	$Second/SecondContent.text = str(floor_num) + "b"


func _on_first_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$First/FirstContent.text = floor_num + ": " + first
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		$First/FirstContent.text = floor_num


func _on_second_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$Second/SecondContent.text = floor_num + ": " + second
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		$Second/SecondContent.text = floor_num
