
extends RigidBody2D

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body == Globals.get("Player"):
		Globals.get("Player").pickup_health()
		queue_free()
