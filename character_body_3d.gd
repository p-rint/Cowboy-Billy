extends CharacterBody3D

@export var cameraDirection = Vector3(0,0,0)
@export var Health = 100
@onready var character = $MeshInstance3D
@onready var camera = $SpringArm3D/Camera3D
@onready var animTree = $MeshInstance3D/Armature/AnimationTree
@onready var curAttack = 0
@onready var timer = $Timer
const SPEED = 10.0
const JUMP_VELOCITY = 4.5

func  _ready() -> void:
	#Engine.time_scale = 1
	
	pass

func comboManager() -> void:
	if curAttack < 3 and timer.time_left > 0:
		curAttack += 1
	else:
		curAttack = 1
		
	print(curAttack)
	timer.start(.5)

func attack(direction) -> void:
	#velocity = direction * 20
	lookDirection(atan2(direction.x, direction.z), 1)
	$MeshInstance3D/Armature/AnimationPlayer.play("testatk")
	#var newenemy = $"../Enemies/CharacterBody3D".duplicate()
	#get_parent().get_node("Enemies").add_child(newenemy)
	
func move(input_dir, delta) -> void:
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	var moveDirection = (right * input_dir.x) + (forward * input_dir.y)
	moveDirection.y = 0 #Remove the camera Y rotation
	moveDirection = moveDirection.normalized()
	

	
	velocity.x = lerp(velocity.x, moveDirection.x * SPEED, delta * 10)
	velocity.z = lerp(velocity.z, moveDirection.z * SPEED, delta * 10)
	
	if moveDirection.length() >= .2:
		lookDirection(atan2(velocity.x, velocity.z), delta * 10)


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	


func lookDirection(direction, lerpAmount) -> void:
	var rotationAngle = lerp_angle($MeshInstance3D.global_rotation.y,direction, lerpAmount)
	
	$MeshInstance3D.global_rotation.y = rotationAngle







#
#
#
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	move(input_dir, delta)
	
	if Input.is_action_just_pressed("Test") and is_on_floor():
		cameraDirection = ((-camera.global_basis.z) * Vector3(1,0,1)).normalized()
		attack(cameraDirection)
		comboManager()
	#print($Area3D.monitoring)
	move_and_slide()
	
	animTree.set("parameters/BlendSpace1D/blend_position", velocity.length()/SPEED)
	
