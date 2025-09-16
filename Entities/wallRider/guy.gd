extends CharacterBody2D

@export var SPEED = 300

var left:bool = false
var right:bool = false
var leftCorner:bool = false
var rightCorner:bool = false

func _physics_process(delta: float) -> void:
	print(left," ",right," ",leftCorner," ",rightCorner)

func _on_wall_rider_on_left(b: bool) -> void:
	left =b
	pass # Replace with function body.


func _on_wall_rider_on_right(b: bool) -> void:
	right =b
	pass # Replace with function body.


func _on_wall_rider_on_right_corner(b: bool) -> void:
	rightCorner=b
	pass # Replace with function body.


func _on_wall_rider_onleft_corner(b: bool) -> void:
	leftCorner=b
	pass # Replace with function body.
