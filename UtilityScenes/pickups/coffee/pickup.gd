extends Area2D
class_name Pickup

@export var pickupType:StringName
@export var scene:Level

var rootPos:Vector2

func _on_ready() -> void:
	rootPos = position
	for i in get_tree().root.get_children():
		if i is Level:
			scene = i
			break
	# notify scene
	scene.add_coffee(self)
	pass # Replace with function body.

var accTime = 0
var freq = 3
var amp = 6
func _process(delta: float) -> void:
	accTime += delta
	position =rootPos+ amp*Vector2.UP* sin(accTime*freq)


func _on_body_entered(body: Node2D) -> void:
	scene.collecte_coffee(self)
	var fadouttween = create_tween()
	fadouttween.set_ease(Tween.EASE_OUT)
	fadouttween.tween_property($Sprite2D2,"modulate",Color.TRANSPARENT,0.2)
	$Sprite2D.visible = false
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)
	$AudioStreamPlayer2D.connect("finished",queue_free)
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.
