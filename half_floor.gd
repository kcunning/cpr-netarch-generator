extends Node2D

var floor_num
var label : String

func set_up_floor(num, content):
	floor_num = num
	label = content
	$First/Content.text = str(floor_num)
	


func _on_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$First/Content.text = floor_num + ": " + label
