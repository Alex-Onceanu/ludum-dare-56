extends Node2D


@onready var current_scene = $village
@onready var possessed_figurines = []


func _on_collection_pressed() -> void:
	current_scene.hide()
	current_scene = $collection
	current_scene.show()
		
func _on_tower_pressed() -> void:
	pass
	
func _on_options_pressed() -> void:
	pass
	
func _on_tournament_pressed() -> void:
	pass

func _ready() -> void:
	$village/collection.pressed.connect(_on_collection_pressed)
	$village/tournament.pressed.connect(_on_collection_pressed)
	$village/tower.pressed.connect(_on_collection_pressed)
	$village/options.pressed.connect(_on_collection_pressed)
	
