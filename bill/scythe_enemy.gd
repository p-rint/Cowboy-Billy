extends CharacterBody3D

@export var Health = 100
@onready var player = $"../../CharacterBody3D2"
@onready var camera = $SpringArm3D/Camera3D
@onready var animTree = $MeshInstance3D/stik4/AnimationTree

@onready var Strafe = false
@onready var Chase = false
@onready var Retreat = false
@export var Stunned = false

const SPEED = 6.0
const JUMP_VELOCITY = 2


func move(delta) -> void:
	
	var forward = $MeshInstance3D.global_basis.z.normalized()
	var right = $MeshInstance3D.global_basis.x.normalized()
	
	var toPlayer = player.position - position
	toPlayer.y = 0
	
	var moveDirection = Vector3() 
	var lookDirection = 0
	var lerpAmt = 10
	
	if Chase:
		#Move forward
		moveDirection += forward
		lookDirection = atan2(toPlayer.x, toPlayer.z)
		lerpAmt = 2
	if Strafe:
		#Move Right
		moveDirection += forward * 2
		lookDirection = atan2(toPlayer.x, toPlayer.z) - PI/2.2
	if Retreat:
		#Move Back a bit
		moveDirection -= forward
		lookDirection = atan2(velocity.x, velocity.z)
	moveDirection.y = 0 #Remove the camera Y rotation
	#print(moveDirection.length())
	#moveDirection = (moveDirection).normalized()
	
	
	
	
	velocity.x = lerp(velocity.x, moveDirection.x * SPEED, delta * 10)
	velocity.z = lerp(velocity.z, moveDirection.z * SPEED, delta * 10)
	
	if moveDirection.length() >= .2:
		#lookDirection(atan2(velocity.x, velocity.z), delta * 10)
		lookDirection(lookDirection, delta * lerpAmt)


func lookDirection(direction, lerpAmount) -> void:
	var rotationAngle = lerp_angle($MeshInstance3D.global_rotation.y,direction, lerpAmount)
	
	$MeshInstance3D.global_rotation.y = rotationAngle


func stateManager(dist) -> void:
	if Stunned == true and $Timers/Stun.time_left > 0:
		Chase = false
		Strafe = false
		Retreat = false
		return
	else: 
		
		Stunned = false
		
		
		
	if dist > 18: # If too far, walk straight 
		Chase = true
		Strafe = false
		Retreat = false
	if dist <= 16: #If close enough, strafe
		Strafe = true
		Chase = false 
		if dist <= 8: #If too close , back up
			Retreat = true
	#print(dist)


#
#
#
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	stateManager((position - player.position).length())
	move(delta)
	move_and_slide()
	
	if Health <= 0:
		queue_free()
		$"../../CharacterBody3D2".Health += 10
	if position.y <= -10 and position.y > -1000:
		queue_free()
		$"../../CharacterBody3D2".Health += 10
	
	#print(Strafe)
	#print(Chase)
	#print(Retreat)
	animTree.set("parameters/BlendSpace1D/blend_position", velocity.length()/SPEED)
	
	
