extends CharacterBody3D

func _ready():
	set_process(false)
	visible = false

func _on_timer_2_timeout():
	set_process(true)
	visible = true
