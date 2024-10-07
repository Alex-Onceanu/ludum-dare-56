extends Node2D

@onready var nickname = "unnamed"
@onready var health = 0
@onready var dmg_stat = 0 
@onready var movement =[] # liste de vecteurs mouvement
@onready var attack = [] # liste des cases touchées par l'attaque de la pièce, relativement à sa position
