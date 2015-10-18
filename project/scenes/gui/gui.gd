
extends CanvasLayer

const MASK_MAXY = 56
const MASK_MINY = 112

func _ready():
	Globals.set("GUI", self)
	set_gas_porcentage(1)

func set_gas_porcentage(gas):
	gas = clamp(gas, 0, 1)
	
	var pos = get_node("gas_mask").get_pos()
	pos.y = MASK_MAXY + ((MASK_MINY - MASK_MAXY) * (1 - gas))
	get_node("gas_mask").set_pos(pos)
