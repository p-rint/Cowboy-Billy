extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PlayerHealth.text =  "PLR Health:  " + str($"../../CharacterBody3D2".health)
	if $"../../Enemies/EnemyBody3D":
		$EnemyHealth.text =  "ENMY Health:  " + str($"../../Enemies/EnemyBody3D".health)	
	else:
		$EnemyHealth.text =  "ENMY Health:  " + "0"
