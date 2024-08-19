extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", func(name: StringName):
		if name != "RESET":
			$AnimationPlayer.play("RESET"));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play():
	$AnimationPlayer.play("death");

func reset():
	get_tree().reload_current_scene();

func set_circle_position(position: Vector2):
	$CanvasLayer/ColorRect.material.set_shader_parameter("circle_centre", position);
