extends Node2D

@onready var rng = RandomNumberGenerator.new()

@onready var bots = [preload("res://assets/figurines/pumpkin_bot.png"), preload("res://assets/figurines/skeleton_bot.png"), preload("res://assets/figurines/zombie_bot.png")]
@onready var mids = [preload("res://assets/figurines/pumpkin_mid.png"), preload("res://assets/figurines/skeleton_mid.png"), preload("res://assets/figurines/zombie_mid.png")]
@onready var tops = [preload("res://assets/figurines/pumpkin_top.png"), preload("res://assets/figurines/skeleton_top.png"), preload("res://assets/figurines/zombie_top.png")]

const names_top = ["pu", "ske", "zo"]
const names_mid = ["mp", "le", "mb"]
const names_bot = ["kin", "ton", "ie"]

@onready var fig_blueprint = preload("res://scenes/figurine.tscn")

@onready var is_something_selected = false
@onready var anim_elapsed_time = 0.0
const anim_total = 0.5

func reset_anim():
	is_something_selected = false
	anim_elapsed_time = 0.0
	$selected.position = Vector2i(282, -64)

func create_figurine():
	var fig = fig_blueprint.instantiate()
	var image = Image.create(32, 64, false, Image.FORMAT_RGBA8)
	var bo = rng.randi_range(0, 2)
	var mi = rng.randi_range(0, 2)
	var to = rng.randi_range(0, 2)
	
	for s in [bots[bo], mids[mi], tops[to]]:
		image.blend_rect(s.get_image(), Rect2i(Vector2i.ZERO, s.get_image().get_size()), Vector2i.ZERO)

	fig.get_node("sprite").texture = ImageTexture.create_from_image(image)
	
	fig.nickname = names_top[to] + names_mid[mi] + names_bot[bo]
	return fig

func _on_gambling_pressed():
	var new_fig = create_figurine()
	get_parent().possessed_figurines.push_back(new_fig)
	
	$figurine_list.add_item(new_fig.nickname, new_fig.get_node("sprite").texture, true)
	reset_anim()
	$selected.texture = new_fig.get_node("sprite").texture
	is_something_selected = true
	
func _ready():
	$selected.scale = Vector2i(3.0, 3.0)
	
func _process(delta):
	if is_something_selected and anim_elapsed_time < anim_total:
		anim_elapsed_time += delta
		var t = anim_elapsed_time / anim_total
		$selected.position.y = 260 * t * t - 64 * (1.0 - t * t)

func _on_figurine_list_item_selected(index: int) -> void:
	reset_anim()
	$selected.texture = get_parent().possessed_figurines[index].get_node("sprite").texture
	is_something_selected = true
