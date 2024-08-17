extends Node2D

@export var SHAPE: RectangleShape2D;
var dragging := Vector2.ZERO;
var relative_to: Vector2;
var cumulative_delta := Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	# STARTING_SHAPE = STARTING_SHAPE;
	update_size();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_size():
	$Area/Collision.shape = SHAPE;
	$Area/Collision/NinePatchRect.size = SHAPE.size;
	$Area/Collision/NinePatchRect.position = -SHAPE.size / 2;
	for child in $Area/Collision/NinePatchRect.get_children():
		child.emit_signal("resized");
	

func update_region_collision_box(region_path: StringName):
	var region := get_node(\
		"Area/Collision/NinePatchRect/" + region_path) as Control;
	var area := region.get_child(0) as Area2D;
	var collision := area.get_child(0) as CollisionShape2D;
	var shape := collision.shape if collision.shape != null else RectangleShape2D.new();
	shape.size = region.size;
	collision.shape = shape;
	collision.position = collision.shape.size / 2;
	

func _unhandled_input(event):
	if dragging != Vector2.ZERO and event is InputEventMouse:
		var ignore_axes: Vector2 = dragging.abs();
		var local_mouse_position: Vector2 = $Area.get_local_mouse_position();
		var mouse_position: Vector2 = \
			local_mouse_position * \
			ignore_axes;
		var delta: Vector2 = (mouse_position - relative_to).snapped(Vector2.ONE);
		$Area.position -= delta - cumulative_delta;
		SHAPE.size += delta - cumulative_delta;
		cumulative_delta += delta - cumulative_delta;
		update_size();
	if event is not InputEventMouseButton:
		return
	if !(event as InputEventMouseButton).pressed:
		dragging = Vector2.ZERO;
	

func potential_resize_starting(viewport: Node, event: InputEvent, shape_idx: int, direction: Vector2):
	if event is not InputEventMouseButton:
		return
	if (event as InputEventMouseButton).pressed:
		dragging = direction
		relative_to = $Area.get_local_mouse_position();
	
