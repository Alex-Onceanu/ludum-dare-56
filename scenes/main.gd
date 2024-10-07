extends Node2D

@onready var possessed_figurines = []
const team_size = 6
@onready var team = []
@onready var selected_scene = $title
@onready var combat_blueprint = preload("res://scenes/combat/combat.tscn")
@onready var is_farming = false
@onready var figurine_blueprint = preload("res://scenes/figurine.tscn")

func _on_collection_pressed() -> void:
	$village.hide()
	$collection.reset_anim()
	$collection.show()
	selected_scene = $collection
		
func _on_tournament_pressed() -> void:
	$village.hide()
	$tournament.update()
	$tournament.show()
	selected_scene = $tournament
	
func _on_options_pressed() -> void:
	$village.hide()
	$options.show()
	selected_scene = $options
	
func _on_dojo_pressed() -> void:
	$village.hide()
	$dojo.show()
	selected_scene = $dojo
	
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

func _on_combat_end_battle(win):
	if win:
		if is_farming:
			$collection.nb_coins += 5
		else:
			$collection.nb_coins += 3
		$"collection/coins".text = "* " + str($collection.nb_coins)
		$tournament.current_level += 1
	selected_scene.queue_free()
	selected_scene = $village
	selected_scene.show()
	

func start_battle():
	if team.size() <= 0:
		return
	selected_scene = combat_blueprint.instantiate()
	var team_figurines = []
	for i in range(len(team)):
		team_figurines.append(possessed_figurines[team[i]])
	selected_scene.set_ingame_pieces(team_figurines, $tournament.enemies_per_level[$tournament.current_level])
	selected_scene.end_battle.connect(_on_combat_end_battle)
	add_child(selected_scene)
	selected_scene.show()
	$tournament.hide()
	is_farming = false
	
func start_farm():
	if team.size() <= 0:
		return
	selected_scene = combat_blueprint.instantiate()
	
	var team_figurines = []
	for i in range(len(team)):
		team_figurines.append(possessed_figurines[team[i]])
		
	var enemy_figurines = []
	const nb_enemies_farm = 3
	for j in range(nb_enemies_farm):
		var e = figurine_blueprint.instantiate()
		e.create_figurine($collection.rng.randi_range(0, 3), $collection.rng.randi_range(0, 3), $collection.rng.randi_range(0, 3), true)
		enemy_figurines.push_back(e)
		
	selected_scene.set_ingame_pieces(team_figurines, enemy_figurines)
	selected_scene.end_battle.connect(_on_combat_end_battle)
	add_child(selected_scene)
	selected_scene.show()
	$dojo.hide()
	is_farming = true
	

func _ready() -> void:
	$collection.hide()
	
	$village/collection.pressed.connect(_on_collection_pressed)
	$village/tournament.pressed.connect(_on_tournament_pressed)
	$village/dojo.pressed.connect(_on_dojo_pressed)
	$village/options.pressed.connect(_on_options_pressed)
	
	$collection/exit.pressed.connect(_on_exit_pressed)
	$collection/team.pressed.connect(_on_team_pressed)
	
	$tournament/exit.pressed.connect(_on_exit_pressed)
	$tournament/play.pressed.connect(start_battle)
	
	$dojo/exit.pressed.connect(_on_exit_pressed)
	$dojo/play.pressed.connect(start_farm)
	
	$options/exit.pressed.connect(_on_exit_pressed)
	$title/exit.pressed.connect(_on_exit_pressed)
