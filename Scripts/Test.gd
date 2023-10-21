extends Node3D
@onready var rope = $rope
@onready var sphere = $Sphere

# Called when the node enters the scene tree for the first time.
func _ready():
	#var rope = get_node("rope")
	#var sphere = get_node("Sphere")
	print(sphere.get_position())
	#bone_top.position = (0,0,0)
	#for i in rope.skeleton.get_bone_count(): 
	#	var bone_name = rope.skeleton.get_bone_name(i)
	#	var id = rope.skeleton.find_bone(bone_name)
	pass # Replace	print(bone_top, bone_bottom) with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = sphere - rope
	direction = direction.normalized()
	pass
