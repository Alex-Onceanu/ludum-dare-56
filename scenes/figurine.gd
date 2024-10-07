extends Node2D

@onready var nickname = "unnamed"
@onready var health = 0
@onready var dmg_stat = 0 
@onready var movement = Vector2(0,0) # vecteur mouvement
@onready var attack = [] # liste des cases touchées par l'attaque de la pièce, relativement à sa position
