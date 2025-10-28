extends Node3D

var mouseCaptured = true

var lockingOn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func lockOn(delta) -> void:
	look_at($"../../Enemies/EnemyBody3D".position)
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if mouseCaptured == true:
			rotation.y -= event.relative.x * .005
			rotation.y = wrapf(rotation.y, 0, TAU)
			rotation.z -= event.relative.y * .005
			rotation.z = clamp(rotation.x, -PI/2.5, PI/4)
			
			#print(rotation.y)
	
	if event.is_action_pressed("Escape"):
		if mouseCaptured == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouseCaptured = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouseCaptured = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#look_at($"../../Enemies/EnemyBody3D".position)
	if lockingOn:
		lockOn(delta)
	pass
