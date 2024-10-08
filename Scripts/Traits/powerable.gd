extends Node

signal power_changed(power: Constants.Power);

## Determines whether or not powering this object moves it to BOOTING instead
## of ON
@export var BOOTING: bool = false;
## Determines the prebuilt effects, if any, of the object
## NONE does nothing
## FREEZE disables all physics for the object when unpowered
## DESTROY calls `call_deferred("queue_free")` on the object when unpowered
@export var TYPE: Constants.PowerableType = Constants.PowerableType.NONE;
var _on_depower_callback: Callable = func(): pass;
var _on_power_callback: Callable = func(): pass;
var power_state: Constants.Power = Constants.Power.OFF:
	set(new_state):
		power_state = new_state
		match new_state:
			Constants.Power.ON:
				power_changed.emit(new_state);
				_on_power_callback.call();
			Constants.Power.OFF:
				power_changed.emit(new_state);
				_on_depower_callback.call();
			Constants.Power.BOOTING:
				power_changed.emit(new_state);
var booting_timer: Timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	if BOOTING:
		booting_timer = Timer.new();
		booting_timer.wait_time = 0.25;
		booting_timer.connect("timeout", _awaken);
		add_child(booting_timer);128
	
	var window = get_tree().get_first_node_in_group("window");
	if window == null:
		push_warning("Could not find window");
		return
	if get_parent() is Area2D:
		window.get_child(0).call_deferred("connect", "area_entered", _on_window_entry);
		window.get_child(0).call_deferred("connect", "area_exited", _on_window_exit);
	else:
		window.get_child(0).call_deferred("connect", "body_entered", _on_window_entry);
		window.get_child(0).call_deferred("connect", "body_exited", _on_window_exit);
	
	match TYPE:
		Constants.PowerableType.NONE:
			pass
		Constants.PowerableType.FREEZE:
			var parent = get_parent();
			if parent is RigidBody2D:
				_on_depower_callback = func():
					parent.set_deferred("freeze", true);
				_on_power_callback = func():
					parent.set_deferred("freeze", false);
		Constants.PowerableType.DESTROY:
			_on_depower_callback = func():
				get_parent().call_deferred("die");
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_power(powered: bool):
	power_state = \
		(Constants.Power.BOOTING if BOOTING else Constants.Power.ON) \
		if powered else Constants.Power.OFF;
	if power_state == Constants.Power.BOOTING:
		booting_timer.start();

func _awaken():
	if power_state == Constants.Power.BOOTING:
		power_state = Constants.Power.ON;

func _on_window_entry(body: Node2D):
	if body == get_parent():
		set_power(true);

func _on_window_exit(body: Node2D):
	if body == get_parent():
		set_power(false);
