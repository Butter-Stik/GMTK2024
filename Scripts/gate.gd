@tool
extends StaticBody2D

@export var COLOR: Constants.SwitchColor = Constants.SwitchColor.GREY:
	set(new_color):
		COLOR = new_color;
		if Engine.is_editor_hint(): update_color();
@export var INVERTED: bool = false;

func update_color():
	match COLOR:
		Constants.SwitchColor.GREY:
			$AnimatedSprite2D.sprite_frames = preload("res://Assets/Gates/grey_gate.tres");
		Constants.SwitchColor.RED:
			$AnimatedSprite2D.sprite_frames = preload("res://Assets/Gates/red_gate.tres");
		Constants.SwitchColor.YELLOW:
			$AnimatedSprite2D.sprite_frames = preload("res://Assets/Gates/yellow_gate.tres");
		Constants.SwitchColor.BLUE:
			$AnimatedSprite2D.sprite_frames = preload("res://Assets/Gates/blue_gate.tres");
		Constants.SwitchColor.PURPLE:
			$AnimatedSprite2D.sprite_frames = preload("res://Assets/Gates/purple_gate.tres");

var state: bool = false:
	set(new_state):
		if new_state == state:
			return
		state = new_state;
		if new_state != INVERTED:
			set_collision_layer_value(1, false);
			$AnimatedSprite2D.play(\
				"open_on" \
				if $Powerable.power_state == Constants.Power.ON \
				else "open_off");
		else:
			set_collision_layer_value(1, true);
			$AnimatedSprite2D.play(\
				"closed_on" \
				if $Powerable.power_state == Constants.Power.ON \
				else "closed_off");

func _ready():
	update_color();
	if INVERTED == true:
		set_collision_layer_value(1, false);
		$AnimatedSprite2D.play(\
			"open_on" \
			if $Powerable.power_state == Constants.Power.ON \
			else "open_off");
	else:
		set_collision_layer_value(1, true);
		$AnimatedSprite2D.play(\
			"closed_on" \
			if $Powerable.power_state == Constants.Power.ON \
			else "closed_off");

func on_trigger_state_changed(new_state: bool):
	state = new_state;
	$Audio.play();
	($Audio.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip_by_name(\
		"open" if new_state else "close");

func _on_power_changed(power):
	if power == Constants.Power.ON:
		$AnimatedSprite2D.play("open_on" if state != INVERTED else "closed_on");
	else:
		$AnimatedSprite2D.play("open_off" if state != INVERTED else "closed_off");


func _on_button_state_changed(pressed: bool) -> void:
	pass # Replace with function body.
