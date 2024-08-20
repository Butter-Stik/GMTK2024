extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	$"/root/Death".ACTIVE_LEVEL = $"/root/Death".LEVELS_COMPLETED + 1;
	$"/root/Death".NEXT_SCENE = "res://Scenes/room%d.tscn" % min($"/root/Death".LEVELS_COMPLETED + 1, 20);
	$"/root/Death".BUTTON_POSITION = global_position + size / 2;
	$"/root/Death".play("enter");

func _on_level_select_pressed():
	$"/root/Death".NEXT_SCENE = "res://Scenes/level_menu.tscn";
	$"/root/Death".play("menu");

func _on_quit_pressed():
	get_tree().quit();
