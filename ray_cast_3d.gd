extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Test"):
		#target_position = ($"../../../../CharacterBody3D2".position - position) * 5
	if $".".is_colliding():
		print("a")
