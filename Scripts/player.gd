extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 300.0
@export var power_state: Constants.Power = Constants.Power.ON;

func _physics_process(delta: float) -> void:
	# moved to function so it can be turned off more easily later
	var old_velocity := Vector2.ZERO; # dummy value
	if power_state == Constants.Power.ON:
		old_velocity = run_physics(delta)
	
	proc_anims(old_velocity);

func run_physics(delta: float) -> Vector2:
	# Add the gravity.
	var old_velocity := velocity;
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		print(velocity.y);

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	return old_velocity;

func proc_anims(old_velocity: Vector2) -> void:
	# # debug messages
	# var animstate: String = $sprite.animation;
	if power_state == Constants.Power.OFF:
		$sprite.play("off");
	elif power_state == Constants.Power.BOOTING:
		$sprite.play("awake");
	elif old_velocity.y * velocity.y < 0.0:
		$sprite.play("apex");
	elif old_velocity.y != velocity.y and old_velocity.y == 0.0:
		$sprite.play("launch");
	elif old_velocity.y != velocity.y and velocity.y == 0.0:
		$sprite.play("land");
	elif velocity.y > 0.0:
		$sprite.play("fall");
	elif velocity.y < 0.0:
		$sprite.play("jump");
	elif velocity.x != 0.0:
		$sprite.flip_h = velocity.x < 0.0;
		$sprite.play("walk");
	else:
		$sprite.play("idle");
	# # debug messages
	# if animstate != $sprite.animation:
	# 	print($sprite.animation);
