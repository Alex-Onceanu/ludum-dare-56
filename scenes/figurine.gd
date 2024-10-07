extends Node2D

@onready var nickname = "unnamed"

const bots = [preload("res://assets/figurines/pumpkin_bot.png"), preload("res://assets/figurines/skeleton_bot.png"), preload("res://assets/figurines/zombie_bot.png"), preload("res://assets/figurines/cthulhu_bot.png")]
const mids = [preload("res://assets/figurines/pumpkin_mid.png"), preload("res://assets/figurines/skeleton_mid.png"), preload("res://assets/figurines/zombie_mid.png"), preload("res://assets/figurines/cthulhu_mid.png")]
const tops = [preload("res://assets/figurines/pumpkin_top.png"), preload("res://assets/figurines/skeleton_top.png"), preload("res://assets/figurines/zombie_top.png"), preload("res://assets/figurines/cthulhu_top.png")]

const names_top = ["pu", "ske", "zo", "cth"]
const names_mid = ["mp", "le", "mb", "ul"]
const names_bot = ["kin", "ton", "ie", "hu"]

const healths = [6, 4, 8, 10]
const dmg_stats = [4, 5, 3, 4]
const movements = [[Vector2(0.0, 1.0), Vector2(0.0, -1.0), Vector2(1.0, 0.0), Vector2(-1.0, 0.0)], [Vector2(0.0, 1.0), Vector2(1.0, 0.0), Vector2(-1.0, 0.0)], [Vector2(0.0, 1.0), Vector2(0.0, 2.0)], [Vector2(1.0, 2.0), Vector2(-1.0, 2.0), Vector2(-2.0, 1.0), Vector2(-2.0, -1.0), Vector2(-1.0, -2.0), Vector2(1.0, -2.0), Vector2(2.0, -1.0)]]
const attacks = [[Vector2(0.0, 1.0), Vector2(-1.0, 2.0), Vector2(1.0, 2.0)], [Vector2(0.0, 1.0), Vector2(1.0, 0.0), Vector2(-1.0, 0.0)], [Vector2(0.0, 1.0), Vector2(-1.0, 1.0)], [Vector2(0.0, 1.0), Vector2(-1.0, 1.0), Vector2(-1.0, 0.0), Vector2(-1.0, -1.0), Vector2(0.0, -1.0), Vector2(1.0, -1.0), Vector2(1.0, 0.0), Vector2(1.0, 1.0)]]
const opp_movements = [[-Vector2(0.0, 1.0), -Vector2(0.0, -1.0), -Vector2(1.0, 0.0), -Vector2(-1.0, 0.0)], [-Vector2(0.0, 1.0), -Vector2(1.0, 0.0), -Vector2(-1.0, 0.0)], [-Vector2(0.0, 1.0), -Vector2(0.0, 2.0)], [Vector2(1.0, 2.0), Vector2(-1.0, 2.0), Vector2(-2.0, 1.0), Vector2(-2.0, -1.0), Vector2(-1.0, -2.0), Vector2(1.0, -2.0), Vector2(2.0, -1.0)]]
const opp_attacks = [[-Vector2(0.0, 1.0), -Vector2(-1.0, 2.0), -Vector2(1.0, 2.0)], [-Vector2(0.0, 1.0), -Vector2(1.0, 0.0), -Vector2(-1.0, 0.0)], [-Vector2(0.0, 1.0), -Vector2(-1.0, 1.0)], [Vector2(0.0, 1.0), Vector2(-1.0, 1.0), Vector2(-1.0, 0.0), Vector2(-1.0, -1.0), Vector2(0.0, -1.0), Vector2(1.0, -1.0), Vector2(1.0, 0.0), Vector2(1.0, 1.0)]]

@onready var health = 0
@onready var dmg_stat = 0
@onready var movement = []
@onready var attack = []

func create_figurine(id_bot, id_mid, id_top, is_enemy):
	var image = Image.create(32, 64, false, Image.FORMAT_RGBA8)
	
	for s in [bots[id_bot], mids[id_mid], tops[id_top]]:
		image.blend_rect(s.get_image(), Rect2i(Vector2i.ZERO, s.get_image().get_size()), Vector2i.ZERO)

	get_node("sprite").texture = ImageTexture.create_from_image(image)
	
	nickname = names_top[id_top] + names_mid[id_mid] + names_bot[id_bot]
	health = healths[id_top]
	dmg_stat = dmg_stats[id_top]
	
	if is_enemy:
		get_node("sprite").flip_h = true
		attack = opp_attacks[id_mid]
		movement = opp_movements[id_mid]
	else:
		attack = attacks[id_mid]
		movement = movements[id_bot]
