extends Node2D

@onready var mousePos1 :=$MousePosition1
@onready var mousePos2 :=$MousePosition2

var direction:Vector2=Vector2.ZERO;
var mouseDown = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal slingShotFire(dir:Vector2)
signal slingShotUpdate(dir:Vector2)


func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.is_pressed()):
		mouseDown = true
		mousePos1.global_position = event.global_position-get_viewport_rect().size/2+get_viewport_rect().position
		mousePos2.global_position = event.global_position-get_viewport_rect().size/2+get_viewport_rect().position
	if(event is InputEventMouseMotion and mouseDown):
		mousePos2.global_position += event.relative
		direction = get_direction(mousePos1.global_position,mousePos2.global_position)
		slingShotUpdate.emit(direction)
	if(event is InputEventMouseButton and event.is_released()):
		direction = get_direction(mousePos1.global_position,mousePos2.global_position)
		mouseDown = false;
		slingShotFire.emit(direction)
		direction = Vector2.ZERO
	
	pass
	
func get_direction(pos1:Vector2,pos2:Vector2) -> Vector2:
	var l:= pos1-pos2;
	var vpRect = get_viewport_rect().size/4
	l = Vector2(l.x/vpRect.x,l.y/vpRect.y).limit_length(1)
	
	
	return l

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
