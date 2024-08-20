@tool
extends MarginContainer
class_name NinePatchButton

signal pressed;

@export var text: String = "":
	set(new_text):
		text = new_text;
		if Engine.is_editor_hint() && get_node("MarginContainer/Button") != null:
			$MarginContainer/Button.text = new_text;

var state: State = State.NORMAL:
	set(new_state):
		if new_state == State.HOVER && state == State.PRESSED:
			return;
		state = new_state;
		match state:
			State.PRESSED:
				$Audio.play();
				$Audio.get_stream_playback().switch_to_clip_by_name("click");
			State.HOVER:
				$Audio.play();
				$Audio.get_stream_playback().switch_to_clip_by_name("hover");
		update_ninepatch();
var hovering: bool = false;

enum State {
	NORMAL,
	PRESSED,
	HOVER
}

func update_ninepatch():
	match state:
		State.NORMAL:
			$NinePatchRect.texture = preload("res://Assets/UI/Button/normal.tres");
		State.PRESSED:
			$NinePatchRect.texture = preload("res://Assets/UI/Button/pressed.tres");
		State.HOVER:
			$NinePatchRect.texture = preload("res://Assets/UI/Button/hover.tres");

func _ready():
	$MarginContainer/Button.text = text;

func _on_button_pressed():
	pressed.emit();

func _on_button_mouse_entered():
	hovering = true;
	if state != State.PRESSED:
		state = State.HOVER;

func _on_button_mouse_exited():
	hovering = false;
	if state != State.PRESSED:
		state = State.NORMAL;

func _on_button_button_down():
	state = State.PRESSED;

func _on_button_button_up():
	if hovering:
		state = State.HOVER;
	else:
		state = State.NORMAL;
