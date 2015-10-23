
extends Area2D

func _ready():
	pass

func _on_powerup_body_enter( body ):
	if body == Globals.get("Player"):
		Globals.get("Player").powerup()
		queue_free()
