#@tool
extends Node2D

var boolList = {"Right":false,"Left":false,"Bottom":false,"BRight":false,"BLeft":false}

func _ready() -> void:
	pass
		
func _physics_process(delta: float) -> void:
		#print(boolList)
		pass
		#print(children)

func isOnLeft():
	return boolList["Left"]
func isOnRight():
	return boolList["Right"]
func isOnleftCorner():
	return not boolList["Bottom"] and boolList["BRight"] and not boolList["BLeft"] and not boolList["Left"] and not boolList["Right"]
func isOnRightCorner():
	return not boolList["Bottom"] and not boolList["BRight"] and boolList["BLeft"] and not boolList["Right"] and not boolList["Left"]
		


var rbo
func _on_right_body_entered(body: Node2D) -> void:
	rbo = body
	boolList["Right"]= true
	$Right.modulate = Color.RED
	pass # Replace with function body.


func _on_right_body_exited(body: Node2D) -> void:
	if(body==rbo):
		boolList["Right"]= false
		$Right.modulate = Color.WHITE
	
	pass # Replace with function body.

var lbo
func _on_left_body_entered(body: Node2D) -> void:
	lbo = body
	boolList["Left"] = true
	$Left.modulate = Color.RED
	
	pass # Replace with function body.


func _on_left_body_exited(body: Node2D) -> void:
	if(lbo==body):
		boolList["Left"] = false
		$Left.modulate = Color.WHITE
	
	pass # Replace with function body.

var lbbo
func _on_bl_body_entered(body: Node2D) -> void:
	lbbo = body
	boolList["BLeft"] = true
	$BL.modulate = Color.RED
	
	pass # Replace with function body.


func _on_bl_body_exited(body: Node2D) -> void:
	if lbbo == body:
		boolList["BLeft"] = false
		$BL.modulate = Color.WHITE
	
	pass # Replace with function body.

var bbo
func _on_bot_body_entered(body: Node2D) -> void:
	bbo= body
	boolList["Bottom"] = true
	$Bot.modulate = Color.RED
	
	pass # Replace with function body.


func _on_bot_body_exited(body: Node2D) -> void:
	if bbo==body:
		boolList["Bottom"] = false
		$Bot.modulate = Color.WHITE
	
	pass # Replace with function body.

var rbbo
func _on_br_body_entered(body: Node2D) -> void:
	rbbo=body
	boolList["BRight"] = true
	$BR.modulate = Color.RED
	
	pass # Replace with function body.


func _on_br_body_exited(body: Node2D) -> void:
	if rbbo==body:
		boolList["BRight"] = false
		$BR.modulate = Color.WHITE
	
	pass # Replace with function body.
