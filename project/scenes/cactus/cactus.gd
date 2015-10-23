
extends Area2D

const FORCE = 1024.0

func _ready():
	if get_scale().x < 0:
		get_node("SpriteOuch").scale(Vector2(-1, 1))
	pass

func _on_cactus_body_enter( body ):
	if body == Globals.get("Player"):
		Globals.get("Player").slow_down()
		get_node("AnimationPlayer").play("ouch")
