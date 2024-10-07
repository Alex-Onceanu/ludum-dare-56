extends Node2D

func _process(delta):
	$team_size.text = "You have " + str(get_parent().team.size())
	
	if get_parent().team.size() > 1:
		$team_size.text += " figurines in your team."
	else:
		$team_size.text += " figurine in your team."
