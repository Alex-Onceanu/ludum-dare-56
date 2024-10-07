extends Node2D

@onready var rng = RandomNumberGenerator.new()

@onready var fig_blueprint = preload("res://scenes/figurine.tscn")

@onready var selected_fig_id = null
@onready var anim_elapsed_time = 0.0
const anim_total = 0.5

@onready var curr_team_i = 0

func reset_anim():
	selected_fig_id = null
	anim_elapsed_time = 0.0
	$selected.position = Vector2i(282, -100)

func _on_gambling_pressed():
	var new_fig = fig_blueprint.instantiate()
	new_fig.create_figurine(rng.randi_range(0, 2), rng.randi_range(0, 2), rng.randi_range(0, 2), false)
	get_parent().possessed_figurines.push_back(new_fig)
	
	$figurine_list.add_item(new_fig.nickname, new_fig.get_node("sprite").texture, true)
	reset_anim()
	$selected.texture = new_fig.get_node("sprite").texture
	selected_fig_id = get_parent().possessed_figurines.size() - 1
	
func _ready():
	$selected.scale = Vector2i(3.0, 3.0)
	
func _process(delta):
	if selected_fig_id != null and anim_elapsed_time < anim_total:
		anim_elapsed_time += delta
		var t = anim_elapsed_time / anim_total
		$selected.position.y = 260 * t * t - 100 * (1.0 - t * t)

func _on_figurine_list_item_selected(index: int) -> void:
	reset_anim()
	$selected.texture = get_parent().possessed_figurines[index].get_node("sprite").texture
	selected_fig_id = index


	
