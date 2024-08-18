@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Window.SHAPE.connect("changed", update_viewport);
	update_viewport();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_viewport():
	$Window/Sprite2D.position = $Window.POSITION;
	$SubViewport.size = $Window.SHAPE.size;
	$SubViewport/Camera2D.position = $Window.POSITION;
