extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(INF,self)
	pass # Replace with function body.
