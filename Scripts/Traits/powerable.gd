extends Node

## Determines whether or not powering this object moves it to BOOTING instead
## of ON
@export var BOOTING: bool = false;
var power_state: Constants.Power = Constants.Power.ON;
var booting_timer: Timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	booting_timer = Timer.new();
	booting_timer.wait_time = 0.25;
	booting_timer.connect("timeout", _awaken);
	add_child(booting_timer);

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
