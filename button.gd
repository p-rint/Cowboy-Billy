extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _pressed() -> void:
	if Engine.get_time_scale() == 1:
		Engine.set_time_scale(0)
		$"../Label2".set_visibility_layer(1)
		$".".text = "Click To Unfreeze"
	else:
		Engine.set_time_scale(1)
		$"../Label2".set_visibility_layer(0)
		$".".text = "PleaseClick"

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
