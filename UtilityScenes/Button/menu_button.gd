extends TextureButton

@export var recenter : Vector2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size/2 +recenter
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_entered() -> void:
	$AnimationPlayer.play("selected")
	pass # Replace with function body.


func _on_focus_exited() -> void:
	#$AnimationPlayer.
	$AnimationPlayer.play("RESET")
	pass # Replace with function body.
