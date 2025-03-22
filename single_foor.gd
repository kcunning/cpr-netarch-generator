extends Node2D
@export var floor_num: String
@export var label : String


func set_up_floor(num, content):
	floor_num = num
	label = content
	print("Single got: ", num, " ", content)
	$Content.text = str(floor_num)
	
func _ready():
	pass


func _on_content_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$Content.text = floor_num + ": " + label
