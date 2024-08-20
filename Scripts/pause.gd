extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		visible = true;
		return;
	if Input.is_action_just_pressed("pause"):
		_on_resume_pressed();

func _on_resume_pressed():
	visible = false;
	get_tree().paused = false;


func _on_menu_pressed():
	get_tree().paused = false;
	$"/root/Death".NEXT_SCENE = "res://Scenes/main_menu.tscn";
	$"/root/Death".play("menu");


func _on_restart_pressed():
	visible = false;
	get_tree().paused = false;
	get_tree().get_first_node_in_group("player").restart();
