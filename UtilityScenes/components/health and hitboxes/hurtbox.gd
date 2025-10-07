class_name HurtBox
extends Area2D

signal received_damage(damage:int)

@export var health:Health

signal incivible (t:bool)

var invince = false
func _ready() -> void:
	$InvinceTimer.connect("timeout",func(): 
		invince = false
		incivible.emit(invince)
	)
	connect("area_entered", _on_area_entered)
	#connect("area_entered", _on_area_entered_heal)

func _on_area_entered(hitbox:Node2D)->void:
	
	if hitbox is HealBox:
		print("healed")
		health.heal(hitbox.get_heal(), hitbox.get_parent())
		
	
	if hitbox is HitBox:
		#print("coool")
		if(!invince):
			health.hit(hitbox.get_damage(), hitbox.get_parent())
			received_damage.emit(hitbox.damage)
			invince = true
			incivible.emit(invince)
			$InvinceTimer.start()
		
		#received_damage.emit(hitbox.damage)
func make_invincible(duration: float = 0.2):
	invince = true
	incivible.emit(true)
	$InvinceTimer.start(duration)
