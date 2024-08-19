extends VBoxContainer

@export var level_number: int = 01;
@export_file("*.tscn") var scene: String;

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(level_number < 100);
	var first_coord = Vector2(4 + level_number / 10, 4);
	var second_coord = Vector2(4 + level_number % 10, 4);
	var first_num_texture = AtlasTexture.new();
	first_num_texture.atlas = preload("res://Assets/Tilesets/off.png");
	first_num_texture.region = Rect2(first_coord * Vector2.ONE * 16 + Vector2(2, 0), Vector2(13, 16));
	var second_num_texture = AtlasTexture.new();
	second_num_texture.atlas = preload("res://Assets/Tilesets/off.png");
	second_num_texture.region = Rect2(second_coord * Vector2.ONE * 16 + Vector2(2, 0), Vector2(13, 16));
	var first_num = TextureRect.new();
	first_num.texture = first_num_texture;
	var second_num = TextureRect.new();
	second_num.texture = second_num_texture;
	$NumberContainer.add_child(first_num);
	$NumberContainer.add_child(second_num);
	alignment = ALIGNMENT_CENTER;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_pressed():
	$"/root/Death".ACTIVE_LEVEL = level_number;
	$"/root/Death".NEXT_SCENE = scene;
	print(scene);
	$"/root/Death".BUTTON_POSITION = global_position + size / 2;
	$"/root/Death".play("enter");

func set_disabled(disabled: bool):
	$Control/TextureButton.disabled = disabled;
