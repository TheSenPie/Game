extends Node3D

@onready var timer = $Timer
@onready var label = $CanvasLayer/Label
@onready var pause_menu = $CanvasLayer/Pause
@onready var player = $Player

var counter = 0

func _ready():
	timer.start()
	#pause_menu.visible = false
	#pause_menu.hidden = true
	pause_menu.hide()

func _process(delta):
	print(timer.time_left)
	label.text = str(timer.time_left).pad_decimals(2).pad_zeros(2)

func _on_timer_timeout():
	print("over")

func _input(event):
	if event.is_action_pressed("Pause"):
		pause_menu.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume_pressed():
	get_tree().paused = false
	pause_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.hide()


func _on_quit_pressed():
	#get_tree().quit()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
