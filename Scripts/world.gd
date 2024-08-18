@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Window.SHAPE.connect("changed", update_viewport);
	update_viewport();
	if Engine.is_editor_hint():
		return;
	var on := TileMapLayer.new();
	var off := TileMapLayer.new();
	on.tile_set = preload("res://Assets/Tilesets/on_tileset.tres");
	off.tile_set = preload("res://Assets/Tilesets/off_tileset.tres");
	for cell_coords in $EditorOnlyOn.get_used_cells():
		var atlas_coords = $EditorOnlyOn.get_cell_atlas_coords(cell_coords);
		on.set_cell( \
			cell_coords, \
			0, \
			atlas_coords);
		off.set_cell( \
			cell_coords, \
			0, \
			atlas_coords + Vector2i(0, 2));
	add_child(off);
	$EditorOnlyOn/TileCollider.reparent(self);
	off.name = "Off";
	$SubViewport.add_child(on);
	on.name = "On";
	$EditorOnlyOn.call_deferred("queue_free");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_viewport():
	$Window/Sprite2D.position = $Window.POSITION;
	$SubViewport.size = $Window.SHAPE.size;
	$SubViewport/Camera2D.position = $Window.POSITION;
