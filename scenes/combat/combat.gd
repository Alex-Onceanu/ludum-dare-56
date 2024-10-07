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
@onready var origin = Vector2(position.x, position.y)
@onready var tile_size = Vector2(32, 16)
@onready var placing_a_piece = false
@onready var current_piece = -1
@onready var current_action = 0 #0 : rien 1 : attack 2 : movement
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
		var square = Vector2(int(temp.x+0.5),int(temp.y+0.5))
		if 0.5 <= temp.x and temp.x <= 8.5 and 0.5 <= temp.y and temp.y <= 8.5:
			if placing_a_piece:
				if can_place_here(square):
					player_pieces[current_piece].position = base_change_back(square)
					player_pieces[current_piece].get_node("sprite").visible = true
					# print(str(event.position.x)+" "+str(event.position.y)+" -> "+str(temp.x)+" "+str(temp.y))
			elif current_action == 1:
				if can_player_attack(square):
					for i in range(5):
						get_node("highlight"+str(i+1)).visible = false
					player_attack(player_pieces[current_piece],player_pieces[current_piece].attack.bsearch(square))
			elif current_action == 2:
				if can_move(square):
					for i in range(5):
						get_node("highlight"+str(i+1)).visible = false
					move(player_pieces[current_piece],player_pieces[current_piece].movement.bsearch(square))				

func set_ingame_pieces(__player_pieces, __enemy_pieces):
	player_pieces = __player_pieces
	enemy_pieces = __enemy_pieces
	for i in range(len(player_pieces)):
		$list.add_item(player_pieces[i].nickname, player_pieces[i].get_node("sprite").texture, true)
	for i in range(len(enemy_pieces)): #on suppose len(enemy_pieces) <= 8 et len(player_pieces) <= 8
		enemy_pieces[i].position = base_change_back(Vector2(i+1,8))
		enemy_pieces[i].get_node("sprite").visible = true
	for i in range(5):
		get_node("highlight"+str(i+1)).visible = false

func player_attack(piece,k):
	for i in range(len(enemy_pieces)):
		if enemy_pieces[i].position == piece.position - piece.attack[k]:
			enemy_pieces[i].health -= piece.dmg_stat
			if enemy_pieces[i].health <= 0:
				enemy_pieces[i].visible = false
				enemy_pieces.remove_at(i)
			break
	
func enemy_attack(piece,k):
	for i in range(len(player_pieces)):
		if player_pieces[i].position == piece.position - piece.attack[k]:
			player_pieces[i].health -= piece.dmg_stat
			if player_pieces[i].health <= 0:
				player_pieces[i].visible = false
				player_pieces.remove_at(i)
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
			if player_pieces[i].position != piece.position + piece.attack[k]:
				return true
	return false
	
func can_enemy_attack(piece):
	for k in range(len(piece.attack)):
		for i in range(len(enemy_pieces)):
			if enemy_pieces[i].position != piece.position + piece.attack[k]:
				return true
	return false
	
func move(piece,j):
	piece.position = piece.position + piece.movement[j]
	
func can_enemy_attack_here(vec):
	for i in range(enemy_pieces):
		if player_pieces[i].position == vec:
			return false
	return true

func attack_value(vector,dmg):
	var vmax = 0
	if not(can_enemy_attack_here(vector)):
		return -1
	for i in range(len(player_pieces)):
		if player_pieces[i].position == vector:
			if dmg >= player_pieces[i].health:
				vmax = max(vmax,dmg+2)
			vmax = max(vmax,dmg)
	return vmax
		
			
func move_value(vector):
	if not(can_move(vector)):
		return -1
	return abs(vector.x)+abs(vector.y)

func _process(_delta):
	if len(player_pieces) == 0:
		emit_signal("end_battle", false)
	elif len(enemy_pieces) == 0:
		emit_signal("end_battle", true)
	elif Input.is_action_just_pressed("validate"):
		placement = false
		$list.visible = false
	elif not(placement):
		if not(is_player_turn):
			var test = [] # triplet piece action valeur case, action = 1 si attack, 2 si movement
			for i in range(len(enemy_pieces)):
				for j in range(len(enemy_pieces[i].attack)):
					test.append([i,1,attack_value(enemy_pieces[i].attack[j],enemy_pieces[i].dmg_stat),j])
				for j in range(len(enemy_pieces[i].movement)):
					test.append([i,2,move_value(enemy_pieces[i].movement[j]),j])
			var acc = 0
			var vmax = 0
			for k in range(len(test)):
				if test[k][2] > vmax:
					vmax = test[k][2]
					acc = k
			if test[acc][1] == 1:
				enemy_attack(enemy_pieces[test[acc][0]],test[acc][3])
			elif test[acc][1] == 2:
				move(enemy_pieces[test[acc][0]],test[acc][3])
					
				
						
		else:
			if current_piece >= 0:
				pass
		

func can_player_attack_here(vec):
	for i in range(player_pieces):
		if player_pieces[i].position == vec:
			return false
	return true

func draw(index: int) -> void:
		placing_a_piece = true
		current_piece = index


func _on_attack_pressed() -> void:
	if not(placement):
		current_action = 1
		for i in range(min(5, len(player_pieces[current_piece].attack))):
			if can_player_attack_here(player_pieces[current_piece].attack[i]):
				get_node("highlight"+str(i+1)).position = base_change_back(player_pieces[current_piece].position + player_pieces[current_piece].attack[i])
				get_node("highlight"+str(i+1)).visible = true


func _on_move_pressed() -> void:
	if not(placement):
		current_action = 2
		for i in range(min(5, len(player_pieces[current_piece].attack))):
			if can_player_attack_here(player_pieces[current_piece].attack[i]):
				get_node("highlight"+str(i+1)).position = base_change_back(player_pieces[current_piece].position + player_pieces[current_piece].attack[i])
				get_node("highlight"+str(i+1)).visible = true
