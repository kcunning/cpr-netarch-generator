extends Node2D

var floor_num : int
var label : String

func set_up_floor(num, content):
	floor_num = num
	label = content
	$First/Content.text = str(floor_num)
	


func _on_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		$First/Content.text = "%d: %s" % [floor_num, label]
