extends Spatial

onready var testy = $StaticBody

func _input(event):
	if Input.is_action_just_released("click"):
		var mouse_posX = get_viewport().get_mouse_position.x()
		var mouse_posY = get_viewport().get_mouse_position.y()
		testy.set_translation(Vector3(mouse_posX,mouse_posY,0))