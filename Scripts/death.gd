extends Node2D

var NEXT_SCENE: String;
var BUTTON_POSITION: Vector2;

var LEVELS_COMPLETED: int = 0:
	set(new_completed):
		LEVELS_COMPLETED = new_completed;
		save_game();
var ACTIVE_LEVEL: int;

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game();
	$AnimationPlayer.connect("animation_finished", func(name: StringName):
		if name != "RESET":
			$AnimationPlayer.play("RESET"));

func play(name: StringName):
	if $AnimationPlayer.current_animation == "death":
		return
	match name:
		"death": set_circle_to_player();
		"next": set_circle_to_breaker();
		"restart": set_circle_to_player();
		"enter": set_circle_to_button();
		"menu": set_circle_to_centre();
	$AnimationPlayer.play(name);

func reset():
	get_tree().reload_current_scene();

func next():
	enter();
	ACTIVE_LEVEL += 1;
	LEVELS_COMPLETED = max(LEVELS_COMPLETED, ACTIVE_LEVEL - 1);

func enter():
	print(NEXT_SCENE);
	get_tree().change_scene_to_file(NEXT_SCENE);
	

func set_circle_position(position: Vector2):
	$CanvasLayer/ColorRect.material.set_shader_parameter("circle_centre", position);

func set_circle_to_player():
	set_circle_position(get_tree().get_first_node_in_group("player").global_position);

func set_circle_to_breaker():
	set_circle_position(get_tree().get_first_node_in_group("breaker").global_position);

func set_circle_to_button():
	set_circle_position(BUTTON_POSITION);

func set_circle_to_centre():
	set_circle_position(Vector2(320.0, 180.0) / 2);

func save_game():
	var save_file := FileAccess.open("user://save", FileAccess.WRITE);
	save_file.store_16(LEVELS_COMPLETED);

func load_game():
	var save_file := FileAccess.open("user://save", FileAccess.READ);
	if save_file == null:
		LEVELS_COMPLETED = 0;
		return;
	LEVELS_COMPLETED = save_file.get_16();
