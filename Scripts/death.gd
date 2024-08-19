extends Node2D

@export_file var next_scene;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", func(name: StringName):
		if name != "RESET":
			$AnimationPlayer.play("RESET"));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play(name: StringName):
	if $AnimationPlayer.current_animation == "death":
		return
	match name:
		"death": set_circle_to_player();
		"next": set_circle_to_breaker();
		"restart": set_circle_to_player();
	$AnimationPlayer.play(name);

func reset():
	get_tree().reload_current_scene();

func next():
	get_tree().change_scene_to_file(next_scene);

func set_circle_position(position: Vector2):
	$CanvasLayer/ColorRect.material.set_shader_parameter("circle_centre", position);

func set_circle_to_player():
	set_circle_position(get_tree().get_first_node_in_group("player").global_position);

func set_circle_to_breaker():
	set_circle_position(get_tree().get_first_node_in_group("breaker").global_position);
