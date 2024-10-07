extends Node2D

@onready var possessed_figurines = []
const team_size = 9
@onready var team = []

@onready var selected_scene = $village

func _on_collection_pressed() -> void:
	$village.hide()
	$collection.reset_anim()
	$collection.show()
	selected_scene = $collection
		
func _on_tower_pressed() -> void:
	pass
	
func _on_options_pressed() -> void:
	pass
	
func _on_tournament_pressed() -> void:
	pass
	
func _on_exit_pressed() -> void:
	selected_scene.hide()
	$village.show()
	selected_scene = $village
	
func _on_team_pressed() -> void:
	if $collection.selected_fig_id == null:
		return
	if $collection.selected_fig_id in team:
		return
	if team.size() >= team_size:
		team.pop_front()
	team.push_back($collection.selected_fig_id)
	get_node("collection/team_view/" + str($collection.curr_team_i + 1)).texture = $collection.get_node("selected").texture
	$collection.curr_team_i = ($collection.curr_team_i + 1) % team_size

func _ready() -> void:
	$collection.hide()
	
	$village/collection.pressed.connect(_on_collection_pressed)
	$village/tournament.pressed.connect(_on_tournament_pressed)
	$village/tower.pressed.connect(_on_tower_pressed)
	$village/options.pressed.connect(_on_options_pressed)
	
	$collection/exit.pressed.connect(_on_exit_pressed)
	$collection/team.pressed.connect(_on_team_pressed)
