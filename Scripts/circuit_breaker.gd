extends Area2D

var pulled: bool = false;
@export var next_level: PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_powerable_power_changed(power: Constants.Power) -> void:
	if pulled == false:
		if $Powerable.power_state == Constants.Power.ON:
			$AnimatedSprite2D.play("not_pulled_on")
		else:
			$AnimatedSprite2D.play("not_pulled_off")

func _on_body_entered(body: Node2D) -> void:
	pulled = true;
	$AnimatedSprite2D.play("pulled");
	$"/root/Death".NEXT_SCENE = next_level;
	(get_tree().get_first_node_in_group("window") as PowerWindow).animate();
	#get_tree().change_scene_to_file(f)
