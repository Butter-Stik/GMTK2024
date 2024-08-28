extends CharacterBody2D
class_name Player
@export var SPEED = 60
@export var JUMP_VELOCITY = 200
@export var PUSH_SPEED = 30
var direction = 0
var speed = SPEED
var pushing = false:
	set(new_pushing):
		pushing = new_pushing;
		if new_pushing:
			speed = Constants.PUSH_SPEED;
		else:
			speed = SPEED;
var dying = false;

var audio_state: AudioState = AudioState.IDLE:
	set(new_state):
		if new_state == audio_state:
			return;
		audio_state = new_state;
		match new_state:
			AudioState.IDLE:
				play_sfx("idle");
			AudioState.JUMP:
				play_sfx("jump");
			AudioState.WALK:
				play_sfx("walk");
			AudioState.DEATH:
				play_sfx("death");
			AudioState.LAND:
				play_sfx("land");
var particle_state: ParticleState = ParticleState.IDLE:
	set(new_state):
		if new_state == particle_state:
			return;
		particle_state = new_state;
		match new_state:
			ParticleState.IDLE:
				$Particles.emitting = false;
			ParticleState.LEFT:
				$Particles.emitting = true;
				$Particles.process_material.direction.x = abs($Particles.process_material.direction.x);
			ParticleState.RIGHT:
				$Particles.emitting = true;
				$Particles.process_material.direction.x = -abs($Particles.process_material.direction.x);
			ParticleState.FALL:
				$FallParticles.emitting = true;

var was_on_floor: bool;
var old_velocity: Vector2 = Vector2.ZERO;

enum AudioState {
	WALK,
	JUMP,
	LAND,
	DEATH,
	IDLE
}

enum ParticleState {
	IDLE,
	LEFT,
	RIGHT,
	FALL
}

func _physics_process(delta: float) -> void:
	old_velocity = velocity;
	if dying:
		return
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true;
		
		return;
	var physics_info := Vector3.ZERO; # dummy value
	if Input.is_action_just_pressed("restart"):
		restart();
	if $Powerable.power_state == Constants.Power.ON:
		physics_info = run_physics(delta);
	proc_anims(Vector2(physics_info.x, physics_info.y), physics_info.z);
	

func run_physics(delta: float) -> Vector3:
	# Add the gravity.
	var old_velocity := velocity;
	if is_on_floor() && !was_on_floor:
		particle_state = ParticleState.FALL;
		$FallParticles.emitting = true;
	if !is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	was_on_floor = is_on_floor();
	move_and_slide()
	
	return Vector3(old_velocity.x, old_velocity.y, direction);

func proc_anims(old_velocity: Vector2, direction: float) -> void:
	# # debug messages
	# var animstate: String = $Sprite.animation;
	if $Powerable.power_state == Constants.Power.OFF:
		$Sprite.play("off");
		audio_state = AudioState.IDLE;
		particle_state = ParticleState.IDLE;
	elif $Powerable.power_state == Constants.Power.BOOTING:
		$Sprite.play("awake");
		audio_state = AudioState.IDLE;
		particle_state = ParticleState.IDLE;
	elif old_velocity.y * velocity.y < 0.0:
		$Sprite.play("apex");
		audio_state = AudioState.IDLE;
		particle_state = ParticleState.IDLE;
	elif old_velocity.y != velocity.y && old_velocity.y == 0.0 && velocity.y < 0.0:
		$Sprite.play("launch");
		audio_state = AudioState.JUMP;
		particle_state = ParticleState.IDLE;
	elif old_velocity.y != velocity.y && velocity.y == 0.0 && is_on_floor():
		$Sprite.play("land");
		audio_state = AudioState.LAND;
		particle_state = ParticleState.IDLE;
		get_tree().get_first_node_in_group("world").shake(max((sqrt(old_velocity.y) - 10) / 12, 0));
	elif velocity.y > 0.0:
		$Sprite.play("fall");
		audio_state = AudioState.IDLE;
	elif velocity.y < 0.0:
		$Sprite.play("jump");
		audio_state = AudioState.IDLE;
		particle_state = ParticleState.IDLE;
	elif direction != 0.0:
		$Sprite.flip_h = direction < 0.0;
		$Sprite.play("walk");
		audio_state = AudioState.WALK;
		particle_state = ParticleState.LEFT if direction < 0.0 else ParticleState.RIGHT;
	else:
		$Sprite.play("idle");
		audio_state = AudioState.IDLE;
		particle_state = ParticleState.IDLE;

func play_sfx(name: String):
	if !$Feet.playing:
		$Feet.play();
	($Feet.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip_by_name(name);

func _on_spikes_body_entered(body: Node2D) -> void:
	if body is Player:
		die()
	

func die():
	$"/root/Death".play("death");
	dying = true;
	$Sprite.set_deferred("speed_scale", 0.5);
	$Sprite.call_deferred("play", "death");
	audio_state = AudioState.DEATH;
	particle_state = ParticleState.IDLE;
	#get_tree().call_deferred("reload_current_scene");
	

func restart():
	$"/root/Death".play("restart");
	dying = true;
	audio_state = AudioState.IDLE;
	particle_state = ParticleState.IDLE;

func _on_powerable_power_changed(power):
	if power == Constants.Power.OFF:
		call_deferred("proc_anims", Vector2.ZERO, 0.0);

func _on_feet_finished():
	return
	match audio_state:
		AudioState.IDLE:
			pass
		AudioState.WALK:
			$Feet.play();
		AudioState.LAND:
			audio_state = AudioState.IDLE;
