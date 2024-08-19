@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return;
	var on := TileMapLayer.new();
	var on_bg := TileMapLayer.new();
	var off := TileMapLayer.new();
	on.tile_set = preload("res://Assets/Tilesets/on_tileset.tres");
	on_bg.tile_set = preload("res://Assets/Tilesets/on_tileset.tres");
	off.tile_set = preload("res://Assets/Tilesets/off_tileset.tres");
	on.z_as_relative = false;
	for cell_coords in $EditorOnlyOn.get_used_cells():
		var atlas_coords = $EditorOnlyOn.get_cell_atlas_coords(cell_coords);
		var source_id = $EditorOnlyOn.get_cell_source_id(cell_coords);
		if source_id == 0:
			on.set_cell( \
				cell_coords, \
				0, \
				atlas_coords);
			off.set_cell( \
				cell_coords, \
				0, \
				atlas_coords + Vector2i(0, 2));
		else:
			on_bg.set_cell( \
				cell_coords, \
				1, \
				atlas_coords);
			off.set_cell( \
				cell_coords, \
				0, \
				Vector2(14,4));
	add_child(off);
	$EditorOnlyOn/TileCollider.reparent(self);
	off.name = "Off";
	get_node("Window/Foreground").add_child(on);
	on.name = "On";
	get_node("Window/Background").add_child(on_bg);
	on_bg.name = "OnBG";
	$EditorOnlyOn.call_deferred("queue_free");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
