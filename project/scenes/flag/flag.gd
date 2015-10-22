
extends Area2D

func _ready():
	pass

func _on_flag_body_enter( body ):
	if body == Globals.get("Player"):
		Globals.get("Player").do_win()
