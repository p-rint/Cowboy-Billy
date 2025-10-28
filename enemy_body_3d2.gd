extends CharacterBody3D


const SPEED = 6.0
const JUMP_VELOCITY = 4.5

@onready var player = $"../../CharacterBody3D2"
@onready var character = $MeshInstance3D
@onready var camera = $MeshInstance3D

@onready var activeBullets = $"../../ActiveBullets"
@onready var bullet = $MeshInstance3D/Bullet

@onready var shootWaitTimer = $Timers/shootWait

var dirToPlayer 

var health = 100
var shootWaitTime = 1 # shoot every ... seconds

var stunTime = .5

var stunned = false

var dead = false

func  _ready() -> void:
	#Engine.time_scale = 1
	shoot()
	pass

func shoot() -> void:
	var newBullet = bullet.duplicate()
	newBullet.position = Vector3(0,0,0)
	character.add_child(newBullet)
	
	newBullet.get_node("Delete").start(.1)
	
	dirToPlayer = (player.position - position)
	
	newBullet.linear_velocity = dirToPlayer.normalized() * 90
	newBullet.rotation.y = atan2(dirToPlayer.x, dirToPlayer.z)
	dealDamage(5)

func dealDamage(damage) -> void:
	player.takedamage(damage)

func move(input_dir, delta) -> void:
	var moveDirection = input_dir
	moveDirection.y = 0 #Remove the camera Y rotation
	moveDirection = moveDirection.normalized()
	

	
	velocity.x = lerp(velocity.x, moveDirection.x * SPEED, delta * 10)
	velocity.z = lerp(velocity.z, moveDirection.z * SPEED, delta * 10)
	
	if moveDirection.length() >= .2:
		lookDirection(atan2(velocity.x, velocity.z), delta * 10)


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	


func lookDirection(direction, lerpAmount) -> void:
	var rotationAngle = lerp_angle(character.global_rotation.y,direction, lerpAmount)
	
	character.global_rotation.y = rotationAngle
	

func startStun() -> void:
	$Timers/Stun.start(stunTime)
	stunned = true


func manageStun() -> void:
	if stunned == true:	
		if $Timers/Stun.time_left == 0:
			stunned = false
			
func die() -> void:
	queue_free()
	

#
#
#
func _physics_process(delta: float) -> void:
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if dead == false:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if stunned == false:
			dirToPlayer = (player.position - position)
			move(dirToPlayer, delta)
		else:
			move(Vector3(0,0,0), delta)
		
		if shootWaitTimer.time_left == 0:
			shoot()
			shootWaitTimer.start(shootWaitTime)
		
		#print($Area3D.monitoring)
		move_and_slide()
		
		
		manageStun()
	else:
		print($Timers/Despawn.time_left)
		if $Timers/Despawn.time_left == 0:
			die()
	
	if health <= 0 and dead == false:
		dead = true
		$Timers/Despawn.start(1)

func takeDamage(damage) -> void:
	health -= damage
