extends Node2D


class BlockNode:
	var body
	var floorType
	#stub until we have not sticakble blocks
	func canStick()->bool:
		return true
		
signal changedMostOccupied(dirs:bool)

var blockNodes :Array[BlockNode]= []


func _ready() -> void:
	pass 
	
func _process(_delta: float) -> void:

	pass
	
func get_block_type(body:Node2D)->BlockNode:
	var b := BlockNode.new()
	b.body = body
	return b

var current = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	changedMostOccupied.emit(true)
	current = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	changedMostOccupied.emit(false)
	if(current==body):
		current = null
		
