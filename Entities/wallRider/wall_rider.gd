#@tool
extends StaticBody2D

var boolList = {"Right":false,"Left":false,"Bottom":false,"BRight":false,"BLeft":false}

signal onLeft (b:bool)
signal onRight (b:bool)
signal onleftCorner(b:bool)
signal onRightCorner(b:bool)


func _ready() -> void:
	pass
		
func _process(delta: float) -> void:
		onLeft.emit(boolList["Left"])
		onRight.emit(boolList["Right"])
		onleftCorner.emit(boolList["Bottom"] and boolList["BRight"] and not boolList["BLeft"])
		onRightCorner.emit(boolList["Bottom"] and not boolList["BRight"] and boolList["BLeft"])
	
	
		pass
		#print(children)
		


func _on_right_body_entered(body: Node2D) -> void:
	boolList["Right"]= true
	pass # Replace with function body.


func _on_right_body_exited(body: Node2D) -> void:
	boolList["Right"]= false
	pass # Replace with function body.


func _on_left_body_entered(body: Node2D) -> void:
	boolList["Left"] = true
	pass # Replace with function body.


func _on_left_body_exited(body: Node2D) -> void:
	boolList["Left"] = false
	
	pass # Replace with function body.


func _on_bl_body_entered(body: Node2D) -> void:
	boolList["BLeft"] = true
	
	pass # Replace with function body.


func _on_bl_body_exited(body: Node2D) -> void:
	boolList["BLeft"] = false
	
	pass # Replace with function body.


func _on_bot_body_entered(body: Node2D) -> void:
	boolList["Bottom"] = true
	pass # Replace with function body.


func _on_bot_body_exited(body: Node2D) -> void:
	boolList["Bottom"] = false
	
	pass # Replace with function body.


func _on_br_body_entered(body: Node2D) -> void:
	boolList["BRight"] = true
	pass # Replace with function body.


func _on_br_body_exited(body: Node2D) -> void:
	boolList["BRight"] = false
	pass # Replace with function body.
