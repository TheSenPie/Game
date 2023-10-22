extends CharacterBody3D

# pathfinding
@onready var nav_agent = $NavigationAgent3D
var SPEED = 3.0
var speed = SPEED

# animations
@onready var anim_player = $AnimationPlayer

# AI
var ai:UtilityAIAgent
var sensor_distance_to_target:UtilityAISensor
var current_action:UtilityAIAction

# state
enum { HUNGRY, TAMED, RUNNING }

var state = HUNGRY

var target_location: Vector3

func _ready():
	var anims = anim_player.get_animation_list()
	for anim_id in anims:
		var anim = anim_player.get_animation(anim_id)
		anim.loop_mode = Animation.LOOP_NONE
	
	ai = $UtilityAIAgent
	sensor_distance_to_target = $UtilityAIAgent/DistanceToTarget
	current_action = null
	
func _process(delta):
	# Sense
	var vec_to_target = target_location - global_transform.origin
	var distance = vec_to_target.length()
	sensor_distance_to_target.sensor_value = distance / 10
	
	# Think
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	
	# Act
	if current_action == null:
		return
	
	# Update the position
	move_and_slide()
	
	# Update otherwise based on current action.
	if current_action.name == "Move":
		if distance <= 4.0:
			current_action.is_finished = true
	elif current_action.name == "Bark":
		current_action.is_finished = true

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_direction = (next_location - current_location).normalized() 
	
	nav_agent.velocity = new_direction * speed
	
	var axis = Vector3.UP;
	var new_angle = atan2(new_direction.x, new_direction.z)
	
	transform.basis = Basis(axis, new_angle)

func update_target_location(target_location):
	self.target_location = target_location
	nav_agent.target_position = target_location

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Rig|Rig|Run"):
		anim_player.seek(0.45, true)
	anim_player.play(anim_name)
	
func _on_navigation_agent_3d_target_reached():
	print("in range")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)

func _on_animation_player_animation_changed(old_name, new_name):
	if (new_name == "Rig|Rig|Run"):
		anim_player.seek(0.45,true)

func _on_utility_ai_agent_action_changed(action_node):
	if action_node == current_action:
		return
	if current_action != null:
		end_action(current_action)
	current_action = action_node
	if current_action != null:
		start_action(current_action)
		
func start_action(action_node):
	if current_action.name == "Move":
		speed = SPEED
		
		if (velocity.length_squared() > 2):
			anim_player.play("Rig|Rig|Run")
		elif (velocity.length_squared() > 4):
			anim_player.play("Rig|Rig|Walk")
			
	elif current_action.name == "Bark":
		speed = 0.0
		
		if (state == HUNGRY):
			anim_player.play("Rig|Rig|Angry")
		else:
			anim_player.play("Rig|Rig|Idle")		
		
func end_action(action_node):
	if current_action.name == "Move":
		pass
	elif current_action.name == "Bark":
		pass
