
extends RigidBody2D

var count = 0

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body == Globals.get("Player"):
		count+=1
	if body == Globals.get("Player") and count == 2:
		Globals.get("Player").pickup_gas(self)
		queue_free()
		pass
