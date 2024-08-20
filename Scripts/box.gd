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
		if STARTS_POWERED:
			$AnimatedSprite2D.play("non_breakable")
		else: 
			$AnimatedSprite2D.play("non_breakable_off")
	elif DESTROY == true:
		if STARTS_POWERED:
			$AnimatedSprite2D.play("breakable")
		else:
			$AnimatedSprite2D.play("breakable_off")
	was_on_floor = is_on_floor();

func _physics_process(delta):
	if $Powerable.power_state == Constants.Power.ON:
		run_physics(delta);

func run_physics(delta: float):
	var pressing_button = false
	for body in $Area2D.get_overlapping_bodies():
		if body.get_parent() is SwitchButton:
			pressing_button = true
	if !pressing_button and $Floor.has_overlapping_bodies():
		if $WallLeft.is_colliding() and !$WallRight.is_colliding():
			velocity.x = 20
		if $WallRight.is_colliding() and !$WallLeft.is_colliding():
			velocity.x = 20
	for body in $Player.get_overlapping_bodies():
		if body == self: continue;
		velocity = 20 * sign(global_position - body.global_position);
	if not is_on_floor():
		if was_on_floor:
			velocity = Vector2.ZERO;
		velocity += get_gravity() * delta;
	
	else:
		if !was_on_floor:
			$Audio.play();
	
		var wall_colliding = $WallLeft.is_colliding() or $WallRight.is_colliding()
		if !wall_colliding:
			velocity.x = 0;
		var active_pushing = false;
		
		for collision_idx in get_slide_collision_count():
			var collision := get_slide_collision(collision_idx);
			var collider = collision.get_collider();
			if collider is not Player && collider is not Pushbox: continue
			if collision.get_collider_velocity().x == 0.0: continue
			velocity = (Constants.PUSH_SPEED-2) * collision.get_normal() * Vector2(1, 0);
			if collider is Player: collision.get_collider().pushing = true;
			active_pushing = true;
		if !active_pushing:
			if !wall_colliding:
				velocity.x = 0;
	
	was_on_floor = is_on_floor();
	var clip_to_button = hitting_button();
	if clip_to_button != 0:
		position += Vector2(clip_to_button, -3);
	else:
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

func hitting_button():
	var hitting = 0;
	for body in $Area2D.get_overlapping_bodies():
		if body.get_parent() is SwitchButton:
			var direction = sign(body.get_parent().global_position - global_position).x;
			if body.global_rotation == 0 && velocity.sign().x == direction:
				hitting = direction;
	return hitting;
