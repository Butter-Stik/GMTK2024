@tool
class_name PowerWindow
extends Node2D

const WINDOW_SIZE: Vector2 = Vector2(320, 180);
@export var SHAPE: RectangleShape2D;
@export var POSITION: Vector2:
	set(new_pos):
		POSITION = new_pos;
		if Engine.is_editor_hint():
			update_size();
@export var CONSTRAINT: Constraint = Constraint.NONE:
	set(new_constraint):
		CONSTRAINT = new_constraint;
		if Engine.is_editor_hint():
			update_constraints();
@onready var window_shape: RectangleShape2D = SHAPE.duplicate();
@onready var window_position: Vector2 = POSITION;
var dragging := Vector2.ZERO;
var mouse_target_offset := Vector2.ZERO;
@export var animating := false:
	set(new_animating):
		animating = new_animating
		if new_animating:
			animation_position = window_position;
			animation_shape = window_shape;
			animation_tl = animation_position - animation_shape.size * Vector2(1, 1) / 2;
			animation_tr = animation_position + animation_shape.size * Vector2(1, -1) / 2;
			animation_bl = animation_position + animation_shape.size * Vector2(-1, 1) / 2;
@export var animation_uv: float = 0.0:
	set(new_uv):
		if !animating: return;
		animation_uv = new_uv;
		var tl_corner = lerp(animation_tl, Vector2(0, 0), new_uv).snapped(Vector2.ONE * 2);
		var tr_corner = lerp(animation_tr, Vector2(320, 0), new_uv).snapped(Vector2.ONE * 2);
		var bl_corner = lerp(animation_bl, Vector2(0, 180), new_uv).snapped(Vector2.ONE * 2);
		var new_position = Vector2((tl_corner.x + tr_corner.x) / 2, (tl_corner.y + bl_corner.y) / 2);
		var new_size = Vector2(tr_corner.x - tl_corner.x, bl_corner.y - tl_corner.y);
		window_position = new_position;
		window_shape.size = new_size;
		update_size();
var animation_position: Vector2;
var animation_shape: RectangleShape2D;
var animation_tl: Vector2;
var animation_tr: Vector2;
var animation_bl: Vector2;

func update_constraints():
	match CONSTRAINT:
		Constraint.NONE:
			$Area/Collision/NinePatchRect.texture = preload("res://Assets/Window/unconstrained.tres");
		Constraint.VERTICAL:
			$Area/Collision/NinePatchRect.texture = preload("res://Assets/Window/vertical.tres");
		Constraint.HORIZONTAL:
			$Area/Collision/NinePatchRect.texture = preload("res://Assets/Window/horizontal.tres");

enum Constraint {
	NONE,
	VERTICAL,
	HORIZONTAL,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# STARTING_SHAPE = STARTING_SHAPE;
	update_constraints();
	update_size();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint(): return

func update_size():
	if Engine.is_editor_hint():
		window_position = POSITION;
		window_shape = SHAPE.duplicate();
	$Area.position = window_position;
	$Area/Collision.shape.size = window_shape.size - Vector2.ONE * 16.1;
	$Area/Collision/NinePatchRect.size = window_shape.size;
	$Area/Collision/NinePatchRect.position = -window_shape.size / 2;
	$Foreground.size = window_shape.size - Vector2.ONE * 16;
	$Foreground/Camera2D.position = window_position;
	$Background.size = window_shape.size - Vector2.ONE * 16;
	$Background/Camera2D.position = window_position;
	$ForegroundSprite.position = window_position;
	$BackgroundSprite.position = window_position;
	for child in $Area/Collision/NinePatchRect.get_children():
		child.emit_signal("resized");
	

func _input(event):
	if dragging != Vector2.ZERO and event is InputEventMouseMotion:
		var scale_offset = dragging * window_shape.size / 2;
		var anchor_point = -scale_offset + window_position;
		var scale_point = scale_offset + window_position;
		var mouse_position = get_local_mouse_position();
		var target_point_position = \
			(mouse_position + mouse_target_offset) \
			* dragging.abs() \
			+ scale_point * (-dragging.abs() + Vector2.ONE);
		target_point_position = target_point_position.snapped(Vector2.ONE * 8);
		target_point_position = target_point_position.clamp(Vector2.ZERO, WINDOW_SIZE);
		var target_point_delta = target_point_position - scale_point;
		var boundary_delta = (anchor_point + (Vector2.ONE * 24.0) * -target_point_delta.sign()) - scale_point;
		target_point_delta = target_point_delta.abs().min(boundary_delta.abs()) * target_point_delta.sign();
		target_point_delta *= dragging.abs();
		
		window_position += target_point_delta / 2;
		window_shape.size += target_point_delta * dragging;
		update_size();
		
	elif event is InputEventMouseButton and \
		!(event as InputEventMouseButton).pressed:
		dragging = Vector2.ZERO;

func region_input(event: InputEvent, direction: Vector2):
	if animating: return;
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		match CONSTRAINT:
			Constraint.HORIZONTAL:
				if direction.y != 0: return;
			Constraint.VERTICAL:
				if direction.x != 0: return;
		dragging = direction;
		mouse_target_offset = dragging * window_shape.size / 2 + window_position \
			- get_local_mouse_position();

func animate():
	$AnimationPlayer.play("span");

func _on_animation_player_animation_finished(anim_name):
	if anim_name != "RESET":
		$AnimationPlayer.play("RESET");
	if anim_name == "span":
		$"/root/Death".play("next");
