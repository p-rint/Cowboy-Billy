extends MeshInstance3D

var a = [$".".position.x, $".".position.y, $".".position.z]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($".".transform)
	print("HowDiDWeGetHere?")
	if a[1] < 0:
		a[1] = 50
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print(area)
