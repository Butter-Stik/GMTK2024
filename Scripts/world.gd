@tool
extends Node2D

@export var screen_shake: ScreenShake;
var do_shake_decay: bool = true;

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
		on.set_cell( \
			cell_coords, \
			0, \
			atlas_coords);
		off.set_cell( \
			cell_coords, \
			0, \
			atlas_coords + Vector2i(0, 2));
	for cell_coords in $EditorOnlyBG.get_used_cells():
		var atlas_coords = $EditorOnlyBG.get_cell_atlas_coords(cell_coords);
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
	$EditorOnlyBG.call_deferred("queue_free");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint(): return;
	var offset_and_rot := screen_shake.feed(delta, do_shake_decay);
	$Camera2D.offset = Vector2(offset_and_rot.x, offset_and_rot.y);
	$Camera2D.rotation = offset_and_rot.z;

func shake(amount: float):
	screen_shake.set_trauma(amount);

func on_trigger_state_changed(pressed: bool) -> void:
	pass # Replace with function body.
