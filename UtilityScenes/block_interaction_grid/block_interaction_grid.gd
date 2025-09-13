extends Node2D


class BlockNode:
	var body
	var floorType

var blockNodes :Array[BlockNode]= []

var dirs:Array[Vector2]

const strToDir :={
	'up':Vector2.UP,
	'right':Vector2.RIGHT,
	'down':Vector2.DOWN,
	'left':Vector2.LEFT,
}

# DO NOT REARAGE NODE ORDER depending on order for votes
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children := get_children()
	var index := 0;
	for i:Area2D in children:
		blockNodes.push_back(null)
		var ind_bodyEnter= func (body:Node2D):
			#print(blockNodes)
			#if blockNodes[index]==null:
			blockNodes[index] = get_block_type(body)
			pass
		var ind_bodyexit = func (body:Node2D):
			#print(blockNodes)
			#if(blockNodes[index] and blockNodes[index].body==body):
			blockNodes[index] = null
			pass
		index+=1
		i.body_exited.connect(ind_bodyexit)
		i.body_entered.connect(ind_bodyEnter)
	pass 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var votes := {"left":0,"right":0,"up":0,"down":0} 
	
	# TL
	if(blockNodes[0]):
		votes["left"]+=1
		votes["up"]+=1
	# TM
	if(blockNodes[1]):
		votes["up"]+=1
	# TR
	if(blockNodes[2]):
		votes["right"]+=1
		votes["up"]+=1
	# ML
	if(blockNodes[3]):
		votes["left"]+=1
	# MR
	if(blockNodes[4]):
		votes["right"]+=1
	#BL
	if(blockNodes[5]):
		votes["left"]+=1
		votes["down"]+=1
	# BM
	if(blockNodes[6]):
		votes["down"]+=1
	# BR
	if(blockNodes[7]):
		votes["right"]+=1
		votes["down"]+=1
	var maxnum = 0
	for i in votes:
		if(votes[i]>maxnum):
			maxnum=0
		
	dirs.clear()
	for alias in votes:
		if(votes[alias]==maxnum):
			dirs.push_back(strToDir[alias])
			
	
	
	#print(dirs)
	pass
	
func get_block_type(body:Node2D)->BlockNode:
	var b := BlockNode.new()
	b.body = body
	return b
