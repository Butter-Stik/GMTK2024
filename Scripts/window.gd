class_name PowerWindow
extends Node2D

@export var SHAPE: RectangleShape2D;
var dragging := Vector2.ZERO;
var mouse_target_offset := Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	# STARTING_SHAPE = STARTING_SHAPE;
	update_size();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_size():
	$Area/Collision.shape.size = SHAPE.size - Vector2.ONE * 16.0;
	$Area/Collision/NinePatchRect.size = SHAPE.size;
	$Area/Collision/NinePatchRect.position = -SHAPE.size / 2;
	for child in $Area/Collision/NinePatchRect.get_children():
		child.emit_signal("resized");
	

func _input(event):
	if dragging != Vector2.ZERO and event is InputEventMouseMotion:
		var scale_offset = dragging * SHAPE.size / 2;
		var anchor_point = -scale_offset + $Area.position;
		var scale_point = scale_offset + $Area.position;
		var mouse_position = get_local_mouse_position();
		var target_point_position = \
			(mouse_position + mouse_target_offset) \
			* dragging.abs() \
			+ scale_point * (-dragging.abs() + Vector2.ONE);
		target_point_position = target_point_position.snapped(Vector2.ONE * 2);
		var target_point_delta = target_point_position - scale_point;
		var boundary_delta = (anchor_point + (Vector2.ONE * 24.0) * -target_point_delta.sign()) - scale_point;
		target_point_delta = target_point_delta.abs().min(boundary_delta.abs()) * target_point_delta.sign();
		print(target_point_delta);
		$Area.position += target_point_delta / 2;
		SHAPE.size += target_point_delta * dragging;
		update_size();
		
	elif event is InputEventMouseButton and \
		!(event as InputEventMouseButton).pressed:
		dragging = Vector2.ZERO;
	

func region_input(event: InputEvent, direction: Vector2):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		dragging = direction;
		mouse_target_offset = dragging * SHAPE.size / 2 + $Area.position \
			- get_local_mouse_position();
