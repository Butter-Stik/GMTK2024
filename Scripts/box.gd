extends CharacterBody2D
class_name Pushbox

@export var DESTROY: bool = false:
	set(new_destroy):
		DESTROY = new_destroy;
		if new_destroy:
			$Powerable.TYPE = Constants.PowerableType.DESTROY;
		else:
			$Powerable.TYPE = Constants.PowerableType.NONE;
@export var STARTS_POWERED: bool = false;
var was_on_floor: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if STARTS_POWERED:
		$Powerable.set_power(STARTS_POWERED);
	if DESTROY == false:
		$Powerable.connect("power_changed", power);
		$AnimatedSprite2D.play("non_breakable")
	elif DESTROY == true:
		$AnimatedSprite2D.play("breakable")
	was_on_floor = is_on_floor();

func _physics_process(delta):
	if $Powerable.power_state == Constants.Power.ON:
		run_physics(delta);

func run_physics(delta: float):
	print(is_on_wall(),get_wall_normal());
	if not is_on_floor():
		if was_on_floor:
			velocity = Vector2.ZERO;
		velocity += get_gravity() * delta;
		if is_on_wall():
			velocity.x += get_wall_normal().x * 20
	else:
		if !was_on_floor:
			$Audio.play();
		
		velocity.x = 0;
		var active_pushing = false;
		
		for collision_idx in get_slide_collision_count():
			var collision := get_slide_collision(collision_idx);
			var collider = collision.get_collider();
			if collider is not Player && collider is not Pushbox: continue
			if collision.get_collider_velocity().x == 0.0: continue
			velocity = Constants.PUSH_SPEED * collision.get_normal() * Vector2(1, 0);
			print(velocity);
			if collider is Player: collision.get_collider().pushing = true;
			active_pushing = true;
		print("---");
		if !active_pushing:
			velocity.x = 0;
	
	print(velocity);
	print("<><><>")
	
	was_on_floor = is_on_floor();
	move_and_slide();
	

func power(new_power: Constants.Power):
	if new_power == Constants.Power.ON:
		$AnimatedSprite2D.play("non_breakable")
	elif new_power == Constants.Power.OFF:
		$AnimatedSprite2D.play("non_breakable_off")

func die():
	$AnimatedSprite2D.play("breakable_fading")
	$AnimatedSprite2D.connect("animation_finished", queue_free)

func _on_area_2d_body_entered(body):
	body.pushing = false;

func _on_area_2d_body_exited(body):
	body.pushing = false;
