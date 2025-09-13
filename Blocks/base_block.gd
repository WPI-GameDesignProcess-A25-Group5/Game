@tool
extends Node2D
class_name BaseBlock

@export var sprite:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = sprite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_editor_state_changed() -> void:
	print("Nyoon")
	pass # Replace with function body.
