extends Node2D


class BlockNode:
	var body
	var floorType
	#stub until we have not sticakble blocks
	func canStick()->bool:
		return true
		
signal changedMostOccupied(dirs:Dictionary)

var blockNodes :Array[BlockNode]= []

var dirs:= {"up":0,"down":0,"left":0,"right":0}

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
			i.modulate = Color.PURPLE
			blockNodes[index] = get_block_type(body)
			pass
		var ind_bodyexit = func (body:Node2D):
			#print(blockNodes)
			#if(blockNodes[index] and blockNodes[index].body==body):
			i.modulate = Color.WHITE
			blockNodes[index] = null
			pass
		index+=1
		i.body_exited.connect(ind_bodyexit)
		i.body_entered.connect(ind_bodyEnter)
	pass 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var votes := {"left":0,"right":0,"up":0,"down":0} 
	
	# TL
	if(blockNodes[0] and blockNodes[0].canStick()):
		votes["left"]+=1
		votes["up"]+=1
	# TM
	if(blockNodes[1] and blockNodes[1].canStick()):
		votes["up"]+=1
	# TR
	if(blockNodes[2] and blockNodes[2].canStick()):
		votes["right"]+=1
		votes["up"]+=1
	# ML
	if(blockNodes[3] and blockNodes[3].canStick()):
		votes["left"]+=1
	# MR
	if(blockNodes[4] and blockNodes[4].canStick()):
		votes["right"]+=1
	#BL
	if(blockNodes[5] and blockNodes[5].canStick()):
		votes["left"]+=1
		votes["down"]+=1
	# BM
	if(blockNodes[6] and blockNodes[6].canStick()):
		votes["down"]+=1
	# BR
	if(blockNodes[7] and blockNodes[7].canStick()):
		votes["right"]+=1
		votes["down"]+=1
	var maxnum = 0
	for i in votes:
		if(votes[i]>maxnum):
			maxnum=votes[i]
	var now	:={"up":0,"down":0,"left":0,"right":0}
	if(maxnum!=0):
		for alias in votes:
			if(votes[alias]==maxnum):
				now[alias]=1
	if(!equivArrs(dirs,now))	:
		dirs = now
		changedMostOccupied.emit(dirs)
	
	
	#print(dirs)
	pass
	
func equivArrs(ar1:Dictionary,ar2:Dictionary)->bool:
	for l in ar1:
		if(ar2[l]==null || ar1[l]!=ar2[l]):
			return false
	return true;
	
func get_block_type(body:Node2D)->BlockNode:
	var b := BlockNode.new()
	b.body = body
	return b
