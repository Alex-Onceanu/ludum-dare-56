extends Sprite2D

func _input(event):
	if event == InputEventMouseButton and event.pressed and event.bouton_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			return true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
