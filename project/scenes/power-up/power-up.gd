
extends Area2D

var count = 0

func _ready():
	pass

func _on_powerup_body_enter( body ):
	if body == Globals.get("Player"):
		count += 1
		if count == 2:
			Globals.get("Player").powerup()
			queue_free()
