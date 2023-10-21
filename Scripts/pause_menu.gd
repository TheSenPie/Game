extends Control

@onready var canvas_layer = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	get_tree().paused = false
	canvas_layer.hide()


func _on_quit_pressed():
	pass



