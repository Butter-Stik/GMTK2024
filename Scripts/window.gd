extends Node2D

@export var SHAPE: RectangleShape2D;
var dragging := Vector2.ZERO;

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
	

func _input(event):
	if dragging != Vector2.ZERO and event is InputEventMouseMotion:
		var mouse_delta := ((event as InputEventMouseMotion).relative * \
			dragging.abs() / \
			get_viewport().get_camera_2d().zoom) \
			.snapped(Vector2.ONE); # ignore 0.0 directions
		SHAPE.size += mouse_delta * dragging;
		SHAPE.size = SHAPE.size.abs().max(Vector2.ONE * 24.0) * SHAPE.size.sign();
		var delta = $Area/Collision/NinePatchRect.size - SHAPE.size;
		print(delta);
		$Area.position -= delta * dragging / 2;
		update_size();
		
	elif event is InputEventMouseButton and \
		!(event as InputEventMouseButton).pressed:
		dragging = Vector2.ZERO;
	

func region_input(event: InputEvent, direction: Vector2):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		dragging = direction;
	
