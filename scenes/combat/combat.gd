extends Node2D

signal figurineClicked

@onready var player_pieces = []
@onready var enemy_pieces = []
@onready var placement = true
@onready var is_player_turn = true
@onready var mmifs = [1150,650]
@onready var tilemap = get_node("TileMapLayer")
@onready var scene = get_node(".")
@onready var origin = Vector2(scene.position.x, scene.position.y)
@onready var tile_size = Vector2(32, 16)
@onready var placing_a_piece = false
@onready var current_piece = -1

func base_change(vector):
	var res = Vector2(0.,0.)
	res.x = (float(1)/float(36)) * (0.5 * (vector.x - origin.x) + (vector.y - origin.y)) #normalisation par 1/48 au lieu de 1/32 car scale 1.5 du tilemaplayer (update en fait 1/36 jsp pk)
	res.y = (float(1)/float(36)) * (0.5 * (vector.x - origin.x) - (vector.y - origin.y))
	return res
	
func base_change_back(vector):
	var res = Vector2(0.,0.)
	res.x = 36*vector.x + 36*vector.y + origin.x
	res.y = 18*vector.x - 18*vector.y + origin.y
	return res

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var temp = base_change(event.position)
		if -0.5 <= temp.x and temp.x <= 8.5 and -0.5 <= temp.y and temp.y <= 8.5:
			if placing_a_piece:
				player_pieces[current_piece].position = base_change_back(Vector2(int(temp.x+0.5),int(temp.y+0.5)))
				player_pieces[current_piece].visible = true
				print(str(event.position.x)+" "+str(event.position.y)+" -> "+str(temp.x)+" "+str(temp.y))

func set_ingame_pieces(__player_pieces, __enemy_pieces):
	player_pieces = __player_pieces
	enemy_pieces = __enemy_pieces

func _ready():
	connect("figurineClicked", draw)
	for i in range(min(8,len(enemy_pieces))):
		enemy_pieces[i].position.x = origin.x + (8 + i) * tile_size.x
		enemy_pieces[i].position.y = origin.y + (8 + i) * tile_size.y
		enemy_pieces[i].visible = true
		
func draw():
	placing_a_piece = true

func _process(_delta):
	if Input.is_action_just_pressed("validate"):
		placement = false
	if placement:
		if placing_a_piece:
			pass
		else:
			pass
				
		
