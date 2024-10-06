extends StaticBody2D

signal figurineClicked

@onready var sprite = get_node("body/body_shape/sprite")

func _input(event):
	if event == InputEventMouseButton and event.press and event.button_index == MOUSE_BUTTON_LEFT:
		connect("has_entered", print_sprite)
		
func print_sprite():
	sprite.visible = true
	emit_signal("figurineClicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
