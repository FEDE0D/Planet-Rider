
extends RigidBody2D

const img_box_broken = preload("box-broken.png")
const img_box = preload("box-full.png")
const ITEM_HEIGHT_SEP = 0.0

export(PackedScene) var item_scn
export(float) var item_change = 0.9

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	get_node("points").set_rot(-get_rot())

func _on_box_body_enter( body ):
	if body == Globals.get("Player"):
		do_break()

func do_break():
	set_layer_mask(0)
	get_node("graphics/Sprite").set_texture(img_box_broken)
	get_node("AnimationPlayer").play("show_points")
	
	if item_scn != null:
		var pos = get_global_pos()
		pos.y -= ITEM_HEIGHT_SEP
		
		var item = item_scn.instance()
		Globals.get("Level").add_item(item)
		item.set_global_pos(pos)
		item.set_rot(-get_rot())
		
		item.apply_impulse(Vector2(), Vector2(1000, -1000))
