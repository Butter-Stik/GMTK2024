@tool
extends Area2D
class_name SwitchButton

signal state_changed(pressed: bool);

@export var COLOR: Constants.SwitchColor = Constants.SwitchColor.GREY:
	set(new_color):
		COLOR = new_color;
		if Engine.is_editor_hint(): update_color();
var queued_bodies = 0;
var bodies = 0;

func update_color():
	match COLOR:
			Constants.SwitchColor.GREY:
				$AnimatedSprite2D.sprite_frames = preload("res://Assets/Buttons/grey_button.tres");
			Constants.SwitchColor.RED:
				$AnimatedSprite2D.sprite_frames = preload("res://Assets/Buttons/red_button.tres");
			Constants.SwitchColor.YELLOW:
				$AnimatedSprite2D.sprite_frames = preload("res://Assets/Buttons/yellow_button.tres");
			Constants.SwitchColor.BLUE:
				$AnimatedSprite2D.sprite_frames = preload("res://Assets/Buttons/blue_button.tres");
			Constants.SwitchColor.PURPLE:
				$AnimatedSprite2D.sprite_frames = preload("res://Assets/Buttons/purple_button.tres");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_color();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if $StaticBody2D/Powerable.power_state == Constants.Power.ON:
		run_physics(delta);
	if $StaticBody2D/Powerable.power_state == Constants.Power.ON:
		if bodies > 0:
			$AnimatedSprite2D.play("pushed_on")
		elif bodies <= 0:
			$AnimatedSprite2D.play("unpushed_on")
	else:
		if bodies > 0:
			$AnimatedSprite2D.play("pushed_off")
		elif bodies <= 0:
			$AnimatedSprite2D.play("unpushed_off")

func run_physics(_delta: float) -> void:
	if queued_bodies != 0:
		if bodies == 0:
			state_changed.emit(true);
		elif bodies + queued_bodies == 0:
			state_changed.emit(false);
	bodies += queued_bodies;
	queued_bodies = 0;


func _on_body_entered(body: Node2D) -> void:
	if body is not StaticBody2D:
		queued_bodies += 1


func _on_body_exited(body: Node2D) -> void:
	if body is Player and bodies == 1:
		bodies = 0
		run_physics(1)
		state_changed.emit(false);
	else:
		queued_bodies -= 1
