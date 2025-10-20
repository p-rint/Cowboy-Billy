extends Area3D

var already_hit = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _handleHit(Enemy, hitDirection) -> void:
	Enemy.Health -= 40
	Enemy.velocity = hitDirection * 30
	Enemy.Stunned = true
	Enemy.get_node("Timers/Stun").start(1)
	Enemy.move_and_slide()
	#Enemy.global_rotation.y = atan2(($"..".position - Enemy.position).x, ($"..".position - Enemy.position).z)
	#print(Enemy.Health)
	Enemy.get_node("MeshInstance3D/stik4/AnimationTree").set("parameters/Attack2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(monitorable)
	if monitoring == true:
		var overlaps = get_overlapping_areas()
		for i in overlaps:
			if not already_hit.has(i): #Not Already hit by hitbox
				already_hit.append(i)
				#print(i)
				
				var camForward = ($"../Node3D/Camera3D".global_basis.z)
				camForward.y = 0
				camForward = camForward.normalized()
				
				_handleHit(i.get_parent(), -camForward)
				#i.get_parent().move_and_slide()

	else:
		already_hit.clear()	
		#print(monitoring)
	


func toggleHitbox() -> void:
	monitoring = not monitoring
