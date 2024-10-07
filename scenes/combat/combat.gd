extends Node2D

signal figurineClicked
signal end_battle(bool)


# échiquier de (1,1) à (8,8)
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
@onready var rng = RandomNumberGenerator.new()

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
	
func can_place_here(vector):
	if vector.y >= 2:
		return false
	for i in range(len(player_pieces)):
		if player_pieces[i].position == vector:
			return false
	return true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and placing_a_piece:
		var temp = base_change(event.position)
		if 0.5 <= temp.x and temp.x <= 8.5 and 0.5 <= temp.y and temp.y <= 8.5:
			if placing_a_piece:
				if can_place_here(Vector2(int(temp.x+0.5),int(temp.y+0.5))):
					player_pieces[current_piece].position = base_change_back(Vector2(int(temp.x+0.5),int(temp.y+0.5)))
					player_pieces[current_piece].get_node("sprite").visible = true
					# print(str(event.position.x)+" "+str(event.position.y)+" -> "+str(temp.x)+" "+str(temp.y))

func set_ingame_pieces(__player_pieces, __enemy_pieces):
	player_pieces = __player_pieces
	enemy_pieces = __enemy_pieces

	for i in range(len(player_pieces)):
		$list.add_item(player_pieces[i].get_node("figurine").nickname, player_pieces[i].get_node("sprite").sprite, true)
	for i in range(len(enemy_pieces)): #on suppose len(enemy_pieces) <= 8 et len(player_pieces) <= 8
		enemy_pieces[i].position = base_change_back(Vector2(i+1,8))
		enemy_pieces[i].get_node("sprite").visible = true
		

func player_attack(piece):
	for k in range(len(piece.attack)):
		for i in range(len(enemy_pieces)):
			if enemy_pieces[i].position == piece.position - piece.attack[k]:
				enemy_pieces[i].health -= piece.dmg_stat
				if enemy_pieces[i].health <= 0:
					enemy_pieces[i].visible = false
				break
	
func enemy_attack(piece):
	for k in range(len(piece.attack)):
		for i in range(len(player_pieces)):
			if player_pieces[i].position == piece.position - piece.attack[k]:
				player_pieces[i].health -= piece.dmg_stat
				if player_pieces[i].health <= 0:
					player_pieces[i].visible = false
				break
			
# Renvoie si piece peut bouger
func can_move(piece):
	for i in range(len(enemy_pieces)):
		if enemy_pieces[i].position == piece.position + piece.movement:
			return false
	for i in range(len(player_pieces)):
		if player_pieces[i].position == piece.position + piece.movement:
			return false
	return true
	
# Renvoie si piece peut attaquer
func can_player_attack(piece):
	for k in range(len(piece.attack)):
		for i in range(len(player_pieces)):
			if player_pieces[i].position == piece.position + piece.attack[k]:
				return false
	return true
	
func can_enemy_attack(piece):
	for k in range(len(piece.attack)):
		for i in range(len(enemy_pieces)):
			if enemy_pieces[i].position == piece.position + piece.attack[k]:
				return false
	return true
	
func move(piece):
	piece.position = piece.position + piece.movement

func _process(_delta):
	if Input.is_action_just_pressed("validate"):
		placement = false
		$list.visible = false
	if not(placement):
		if not(is_player_turn):
			var done = false
			while not(done):
				var k = rng.randi_range(0,len(enemy_pieces))
				var do = rng.randi_range(0,1)
				if do == 1:
					if can_enemy_attack(enemy_pieces[k]):
						done = true
						enemy_attack(enemy_pieces[k])
				else:
					if can_move((enemy_pieces[k])):
						done = true
						move(enemy_pieces[k])
		else:
			pass
		


func draw(index: int) -> void:
		placing_a_piece = true
		current_piece = index
