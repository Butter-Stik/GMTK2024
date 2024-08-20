extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	$"/root/Death".ACTIVE_LEVEL = 1;
	$"/root/Death".NEXT_SCENE = "res://Scenes/room1.tscn";
	$"/root/Death".BUTTON_POSITION = global_position + size / 2;
	$"/root/Death".play("enter");

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn");

func _on_quit_pressed():
	get_tree().quit();
