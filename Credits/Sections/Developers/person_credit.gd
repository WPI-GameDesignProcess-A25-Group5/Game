@tool
extends HBoxContainer

@export var personName:String="NAME"
@export var Roles:Array=["role1","role2","Adifferent Role","LLLLLLOOOOOOOOOONNNNNNNGGG RRRRRROOOOOLLLLLLLEEEEE"]
var RoleNode = preload("res://Credits/Sections/Developers/credit_role.tscn")
func	 _ready() -> void:
	%Name.text=personName +':'
	for a in Roles:
		var role = RoleNode.instantiate()
		role.text=a if a else "BLANK"
		%Roles.add_child(role)
		
func _process(_delta: float) -> void:
	#print("Hi")
	if(Engine.is_editor_hint()):
		#print("yoo")
		var ExistingRoles =%Roles.get_children()
		for i in Roles.size():
			if(ExistingRoles.size()>i):
				if(ExistingRoles[i] is Label):
					ExistingRoles[i].text = Roles[i] if Roles[i] else "BLANK"
					#print(ExistingRoles[i].text)
			else:
				var role = RoleNode.instantiate()
				role.text= Roles[i] if Roles[i] else "BLANK"
				%Roles.add_child(role)
				
			pass
			
