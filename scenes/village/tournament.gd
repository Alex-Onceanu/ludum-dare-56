extends Node2D

@onready var fig_blueprint = preload("res://scenes/figurine.tscn")
@onready var current_level = 0
@onready var enemies_per_level = []
const nb_enemies_per_level = [3, 5, 6, 6, 6]


func _ready():
	$"levels/1".show()
	for i in range(2, 6):
		get_node("levels/" + str(i)).hide()
		
	for level in range(3):
		var tmp = []
		for i in range(nb_enemies_per_level[level]):
			var enemy = fig_blueprint.instantiate()
			enemy.create_figurine(level, level, level, true)
			tmp.push_back(enemy)
		enemies_per_level.append(tmp)
		

func update():
	$div/enemy_img.texture = enemies_per_level[current_level][0].get_node("sprite").texture
	$div/level_nb.text = "Level " + str(current_level + 1)
	$div/enemy_nb.text = "* " + str(nb_enemies_per_level[current_level])
	$team_size.text = "You have " + str(get_parent().team.size())
	
	if get_parent().team.size() > 1:
		$team_size.text += " figurines in your team."
	else:
		$team_size.text += " figurine in your team."
