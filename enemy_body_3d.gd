extends CharacterBody3D

@export var Health = 100
@onready var player = $"../../CharacterBody3D2"
@onready var camera = $SpringArm3D/Camera3D
@onready var animTree = $"../Scythe_Enemy/MeshInstance3D/stik4/AnimationTree"
@onready var windUpTimer = $"../Scythe_Enemy/Timers/Windup"
@onready var AttackTime = $"../Scythe_Enemy/Timers/Attack"
@onready var ChargeTime = $"../Scythe_Enemy/Timers/ChargingTime"
@onready var toPlayer = player.position - position

@onready var AttackAnims = ["parameters/Attack1/request", "parameters/Attack2/request"]

@onready var Strafe = false
@onready var Chase = false
@onready var Retreat = false
@export var Stunned = false
@onready var Attacking = false
@onready var WindingUp = false

@onready var windingUp = false

@onready var curAttack = 0

@onready var atkStart = Vector3()
@onready var plrStart = Vector3()

const SPEED = 6.0
const JUMP_VELOCITY = 2

const WindUpTime = .1


func comboManager() -> void:
	if AttackTime.time_left <= .2: #no attacking imediatly
		if curAttack < 2 and windUpTimer.time_left > 0:
			curAttack += 1
			#attack(curAttack - 1)
		else: #do first attack
			curAttack = 1
			windUpTimer.start(WindUpTime)
			windingUp = true
		
		velocity = toPlayer.normalized() * 40	
		AttackTime.start(.7)

func attack() -> void:
	#velocity = cameraDirection * 20
	lookDirection(atan2(toPlayer.normalized().x, toPlayer.normalized().z), 1)
	animTree.set("parameters/Attack1/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
	$Area3D.monitoring = false
	animTree.set("parameters/Attack1/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	animTree.set("parameters/Windup/blend_amount", 0)
	#$MeshInstance3D/Armature/AnimationPlayer.play("testatk")
	#var newenemy = $"../Enemies/CharacterBody3D".duplicate()
	#get_parent().get_node("Enemies").add_child(newenemy)
	#ChargeTime.start(randf_range(1,3))


func windup() -> void:
	if windUpTimer.time_left > 0:
		animTree.set("parameters/Windup/blend_amount", 1 - (windUpTimer.time_left/WindUpTime))
		
		position = Vector3(atkStart).lerp(plrStart, (1 - windUpTimer.time_left)/WindUpTime)
		
	else: #It's over
		windUpTimer.wait_time = WindUpTime
		#print("timesUp")
		attack()
		windingUp = false
		ChargeTime.wait_time = randf_range(1,3)


func move(delta) -> void:
	
	var forward = $MeshInstance3D.global_basis.z.normalized()
	var right = $MeshInstance3D.global_basis.x.normalized()
	
	toPlayer = player.position - position
	toPlayer.y = 0
	
	var moveDirection = Vector3() 
	
	
	if Chase:
		#Move forward
		moveDirection += forward
	if Strafe:
		#Move Right
		moveDirection += right/1.5
	if Retreat:
		#Move Back a bit
		moveDirection -= forward/4
	moveDirection.y = 0 #Remove the camera Y rotation
	#print(moveDirection.length())
	#moveDirection = (moveDirection).normalized()
	
	
	
	
	velocity.x = lerp(velocity.x, moveDirection.x * SPEED, delta * 10)
	velocity.z = lerp(velocity.z, moveDirection.z * SPEED, delta * 10)
	
	if moveDirection.length() >= .2:
		#lookDirection(atan2(velocity.x, velocity.z), delta * 10)
		lookDirection(atan2(toPlayer.x, toPlayer.z), delta * 10)


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
	
		
		
		
		
	if dist > 16: # If too far, walk straight 
		Chase = true
		Strafe = false
		Retreat = false
	if dist <= 16: #If close enough, strafe
		Strafe = true
		Chase = false 
		if dist <= 8: #If too close , back up
			Retreat = true


#
#ll
#
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	toPlayer.y = 0
	toPlayer = toPlayer.normalized()
		
	
	if Health <= 0:
		queue_free()
		$"../../CharacterBody3D2".Health += 10
	if position.y <= -10 and position.y > -1000:
		queue_free()
		$"../../CharacterBody3D2".Health += 10
	stateManager((position - player.position).length())
	move(delta)
	move_and_slide()
	#if windingUp == true:
		#windup()
	#animTree.set("parameters/BlendSpace1D/blend_position", velocity.length()/SPEED)
	
	
