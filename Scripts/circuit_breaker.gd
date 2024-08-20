extends Area2D

var pulled: bool = false;
@export_file("*.tscn") var next_level: String;
@export var final_breaker: bool = false;

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
	$Audio.play();
	$AnimatedSprite2D.play("pulled");
	print(next_level);
	$"/root/Death".THE_END = final_breaker;
	$"/root/Death".NEXT_SCENE = next_level;
	(get_tree().get_first_node_in_group("window") as PowerWindow).animate();
