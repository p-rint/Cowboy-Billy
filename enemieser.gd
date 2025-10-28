extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Timer".time_left == 0:
	
		var new = $".".get_children(false)[randi_range(0,1)].duplicate()
		#print(enemies.instantiate().get_child(0))
		new.position = Vector3(randf_range(-40,40),2,randf_range(-40,40))
		$"../Enemies".add_child(new)
		$"../Timer".start(randf_range(100,300))
		print("a")
