extends Node2D

@onready var top = get_node("top")
@onready var mid = get_node("mid")
@onready var bot = get_node("bot")

func init_figurine(top_path, mid_path, bot_path):
	var top_img = Image.load_from_file(top_path)
	$top.texture = ImageTexture.create_from_image(top_img)
	
	var mid_img = Image.load_from_file(mid_path)
	$mid.texture = ImageTexture.create_from_image(mid_img)
	
	var bot_img = Image.load_from_file(bot_path)
	$bot.texture = ImageTexture.create_from_image(bot_img)
