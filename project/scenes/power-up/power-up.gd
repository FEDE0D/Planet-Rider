
extends Area2D

var count = 0
var time = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta

func _on_powerup_body_enter( body ):
	if body == Globals.get("Player"):
		count += 1
		if count == 2 or time > 0.5:
			Globals.get("Player").powerup()
			queue_free()
