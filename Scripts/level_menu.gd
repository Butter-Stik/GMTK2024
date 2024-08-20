extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in min($"/root/Death".LEVELS_COMPLETED + 1, $GridContainer.get_child_count()):
		$GridContainer.get_child(i).set_disabled(false);

func _on_reset_pressed():
	$"/root/Death".LEVELS_COMPLETED = 0;
	get_tree().reload_current_scene();


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");
