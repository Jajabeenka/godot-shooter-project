extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal laser(pos, direction)
signal grenade(pos, direction)

func _process(_delta):
	
	#input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * 500
	move_and_slide()
	
	#rotate
	look_at(get_global_mouse_position())
	
	# 200 is speed
#	position += direction * 300 * delta
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	if Input.is_action_just_pressed("primary action") and can_laser:
#		#randomly select a marker2d as the starting point fo the laser
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		$LaserParticles.emitting = true

		can_laser = false
		$LaserTimer.start()
		
		#emit the position that was selected
		
		laser.emit(selected_laser.global_position, player_direction)
		
	if Input.is_action_just_pressed("secondary action") and can_grenade:
		var selected_grenade = $GrenadeStartPosition/GrenadeMarker
	
		can_grenade = false
		$GrenadeTimer.start()

		grenade.emit(selected_grenade.global_position, player_direction)

func _on_laser_timer_timeout() -> void:
	can_laser = true


func _on_grenade_timer_timeout() -> void:
	can_grenade = true
