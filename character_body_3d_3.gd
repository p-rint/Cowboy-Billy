extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

const DASHSPEED = 50

var forward
var right


@onready var character = $CharacterContainer
@onready var camera = $Node3D
@onready var enemy = $"../Enemies/EnemyBody3D"
@onready var moveDirection
@onready var lastMoveDirection
@onready var animPlayer = $"AnimationPlayer"
#@onready var animTree = $"CharacterContainer2/AnimationTree"

@export var health = 100

var isDashing = false

func  _ready() -> void:
	#Engine.time_scale = 1
	print("Stop trying to recreate your dreams")
	print("Place things down until it resembles your dream.")
	pass

func move(input_dir, delta) -> void:
	forward = camera.global_basis.z
	right = camera.global_basis.x
	if not moveDirection == Vector3(0,0,0):
		lastMoveDirection = moveDirection 
	moveDirection = (right * input_dir.x) + (forward * input_dir.y)
	moveDirection.y = 0 #Remove the camera Y rotation
	moveDirection = moveDirection.normalized()
	

	
	velocity.x = lerp(velocity.x, moveDirection.x * SPEED, delta * 10)
	velocity.z = lerp(velocity.z, moveDirection.z * SPEED, delta * 10)
	
	if moveDirection.length() >= .2:
		lookDirection(atan2(velocity.x, velocity.z), delta * 10)
	#animTree.set("parameters/Walk/blend_position", Vector2(velocity.x, velocity.z)/SPEED)

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	

func dash() -> void:
	$Timers/DashTimer.start(.5)
	isDashing = true
	#Get movement direction so you can play an anim in animation tree
	if not moveDirection == Vector3(0,0,0):
		velocity = moveDirection * DASHSPEED
	else:
		velocity = character.global_basis.z * DASHSPEED 
	animPlayer.stop()
	animPlayer.play("Dash")
	
func endDash() -> void:
	isDashing = false
	


func lookDirection(direction, lerpAmount) -> void:
	var rotationAngle = lerp_angle(character.global_rotation.y,direction, lerpAmount)
	
	character.global_rotation.y = rotationAngle
	
func attack() -> void:
	if enemy:
		enemy.velocity =  (enemy.position - position).normalized() * 40
		enemy.move_and_slide()
		enemy.takeDamage(10)
		enemy.startStun()
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

	if Input.is_action_just_pressed("Test"):
		attack()
		print("attack")
	
	if Input.is_action_just_pressed("Dash"):
		dash()
	
	if Input.is_action_just_pressed("LockOn"):
		$Node3D.lockingOn = not $Node3D.lockingOn
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	move(input_dir, delta)
	
	move_and_slide()


	if isDashing == true:
		if $Timers/DashTimer.time_left == 0:
			endDash()
	




func takedamage(Damage):
	if isDashing:
		print("evade attack")
		return
	
	health -= Damage
	
	
	
