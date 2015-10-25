
extends RigidBody2D

var count = 0
var timer = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timer += delta

func _on_Area2D_body_enter( body ):
	if body == Globals.get("Player") and timer > 0.5:
		Globals.get("Player").pickup_health()
		queue_free()
