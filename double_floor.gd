extends Node2D

func set_up_floor(num, cont1, cont2):
	var first = find_child("FirstContent")
	first.text = "%da: %s" % [num, cont1]
	var second = find_child("SecondContent")
	second.text = "%db: %s" % [num, cont1]
