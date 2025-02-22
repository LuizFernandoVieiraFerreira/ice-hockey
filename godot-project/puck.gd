extends CharacterBody2D

class_name Puck
# Exported variable for the goal area detection
@export var goal_area : Area2D  # Goal area for detecting goals

var owner_player: Node2D = null  # The player currently controlling the puck
var offset = Vector2(10, 0)     # Offset for puck position relative to player
var speed = 300                 # Base speed for passes/shots
var friction = 0.98             # Friction when the puck is loose

var is_moving = false           # Is the puck moving?
#var velocity = Vector2.ZERO     # Current puck velocity

#velocity = Vector2.ZERO

func _ready():
	# Connect the signal for when the puck enters a goal area
	goal_area.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

# Update the puck's position each frame if it's moving
func _physics_process(delta):
	if owner_player:
		# Update puck position based on the player's position
		global_position = owner_player.global_position + offset
	else:
		# Update puck's movement if it's moving
		if is_moving:
			# Move puck with velocity
			#move_and_slide(velocity)
			#global_position += velocity * delta
			
			# Move puck with velocity and detect collisions
			var collision = move_and_collide(velocity * delta)
			
			if collision:
				print("Puck collided with:", collision.get_collider().name)
				is_moving = false
				velocity = Vector2.ZERO
			
			# Apply friction
			velocity *= friction
			
			# Stop moving if the puck slows down too much
			if velocity.length() < 5:
				is_moving = false
				velocity = Vector2.ZERO

# Handle the puck being passed to a player (clearing the owner)
func pass_puck(direction: Vector2):
	owner_player = null

# Handle shooting the puck towards the goal (calculating velocity)
func shoot_puck(direction: Vector2):
	owner_player = null
	
	var goal_position = Vector2(255, 0)  # Example goal position, adjust as necessary
	var shot_direction = (goal_position - global_position).normalized()
	
	# Possible shot directions (you can tweak these)
	var possible_directions = [
		Vector2(1, 0),       # East
		Vector2(0.7, -0.7),  # Northeast
		Vector2(0.7, 0.7),   # Southeast
		Vector2(-1, 0),      # West
		Vector2(-0.7, -0.7), # Northwest
		Vector2(-0.7, 0.7)   # Southwest
	]
	
	# Find the direction that matches the shot direction the most
	var best_match = possible_directions[0]
	var best_dot = -1
	for dir in possible_directions:
		var dot = shot_direction.dot(dir)
		if dot > best_dot:
			best_dot = dot
			best_match = dir
	
	# Set the puck's velocity to match the shot direction
	var shot_speed = 200
	velocity = best_match * shot_speed
	is_moving = true

# Pickup the puck for a player
func pick_up_puck(player):
	owner_player = player
	#owner_player = player
	#is_moving = false
	#velocity = Vector2.ZERO
	#global_position = owner_player.global_position + offset

# Update offset when the direction of the puck changes
func update_offset_based_on_direction(direction: Vector2):
	if direction.y < 0 and direction.x == 0:  # North
		offset = Vector2(0, -10)
	elif direction.y < 0 and direction.x > 0:  # Northeast
		offset = Vector2(12, 4)
	elif direction.y == 0 and direction.x > 0:  # East
		offset = Vector2(12, 10)
	elif direction.y > 0 and direction.x > 0:  # Southeast
		offset = Vector2(8, 12)
	elif direction.y > 0 and direction.x == 0:  # South
		offset = Vector2(0, 10)
	elif direction.y > 0 and direction.x < 0:  # Southwest
		offset = Vector2(-8, 12)
	elif direction.y == 0 and direction.x < 0:  # West
		offset = Vector2(-12, 10)
	elif direction.y < 0 and direction.x < 0:  # Northwest
		offset = Vector2(-12, 4)

# Handle the goal scoring
func _on_Area2D_body_entered(body):
	print("Other body entered: ", body)
	#if body is CharacterBody2D and owner_player == null:
		#print("Other body is a Player")
		#body.pick_up_puck(self)
	if body.is_in_group("goal"):
		print("GOAL!!!")
		global_position = Vector2(30, 0)  # Example center position after goal
		velocity = Vector2.ZERO
		is_moving = false
