extends Node2D

@onready var possessed_figurines = []

func _on_collection_pressed() -> void:
	print_debug("pressed")
	$village.hide()
	$collection.reset_anim()
	$collection.show()
		
func _on_tower_pressed() -> void:
	pass
	
func _on_options_pressed() -> void:
	pass
	
func _on_tournament_pressed() -> void:
	pass

func _ready() -> void:
	$collection.hide()
	
	$village/collection.pressed.connect(_on_collection_pressed)
	$village/tournament.pressed.connect(_on_collection_pressed)
	$village/tower.pressed.connect(_on_collection_pressed)
	$village/options.pressed.connect(_on_collection_pressed)
	
