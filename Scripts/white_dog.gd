extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $AnimationPlayer

var SPEED = 3.0

enum { HUNGRY, TAMED, RUNNING }

var state = HUNGRY

func _ready():
	var anims = anim_player.get_animation_list()
	for anim_id in anims:
		var anim = anim_player.get_animation(anim_id)
		anim.loop_mode = Animation.LOOP_NONE

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.velocity = new_velocity
	
	var axis = Vector3.UP;
	var new_angle = atan2(new_velocity.x, new_velocity.z)
	
	transform.basis = Basis(axis, new_angle)


func update_target_location(target_location):
	nav_agent.target_position = target_location
	

func _on_animation_player_animation_finished(anim_name):
	anim_player.seek(0.45, true)
	anim_player.play("Rig|Rig|Run")
	
func _on_navigation_agent_3d_target_reached():
	print("in range")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
	
	if (velocity.length_squared() > 2):
		anim_player.play("Rig|Rig|Run")
	elif (velocity.length_squared() > 4):
		anim_player.play("Rig|Rig|Walk")
	else:
		if (state == HUNGRY):
			anim_player.play("Rig|Rig|Angry")
		else:
			anim_player.play("Rig|Rig|Idle")


func _on_animation_player_animation_changed(old_name, new_name):
	if (new_name == "Rig|Rig|Run"):
		anim_player.seek(0.45,true)
