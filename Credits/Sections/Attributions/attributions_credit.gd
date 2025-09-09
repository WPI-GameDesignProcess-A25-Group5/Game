@tool
extends VBoxContainer

@export var attribName:String="NAME"
@export var copyright:String="BLANK"
@export var license:String= "BLANK"
var RoleNode = preload("res://Credits/Sections/Attributions/attributions_license.tscn")
func	 _ready() -> void:
	%Name.text=attribName
	var role = RoleNode.instantiate()
	%Roles.add_child(setCRInfo(role,copyright,license))
		
func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		var ExistingRoles =%Roles.get_child(0)
		if(ExistingRoles is Label):
			setCRInfo(ExistingRoles,copyright,license)
				
			pass

func setCRInfo(role:Label,Copyright:String,License:String):
	role.text=Copyright if Copyright else "BLANK"
	role.text+=' '
	role.text+=License if License else "BLANK"
	return role
