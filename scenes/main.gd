extends Node2D

@onready var village_scene = preload("res://scenes/village/village.tscn")
#@onready var collection_scene = preload("res://scenes/village/collection.tscn")
#@onready var tower_scene = preload("res://scenes/village/tower.tscn")
#@onready var tournament_scene = preload("res://scenes/village/tournament.tscn")
#@onready var options_scene = preload("res://scenes/options.tscn")

func _on_collection_pressed() -> void:
	pass
	#get_tree().change_scene_to_packed(collection_scene)
	
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
	
