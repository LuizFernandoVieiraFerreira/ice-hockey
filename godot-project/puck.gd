extends Node2D

class_name Puck

@onready var area2d = $Area2D

var owner_player: Node2D = null # The player currently controlling the puck

var offset = Vector2(10, 0)
var speed = 300 # Base speed for passes/shots
var friction = 0.98 # Friction for when the puck is loose

var is_moving = false

var velocity = Vector2.ZERO

func _ready():
	area2d.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _physics_process(delta):
	if owner_player:
		global_position = owner_player.global_position + offset
	else:
		if is_moving:
			global_position += velocity * delta
			velocity *= friction
			if velocity.length() < 5:
				is_moving = false
				velocity = Vector2.ZERO

func pass_puck(direction: Vector2):
	owner_player = null

func shoot_puck(direction: Vector2):
	owner_player = null
	
	var goal_position = Vector2(255, 0)
	var shot_direction = (goal_position - global_position).normalized()
	
	var possible_directions = [
		Vector2(1, 0),       # East
		Vector2(0.7, -0.7),  # Northeast
		Vector2(0.7, 0.7),   # Southeast
		Vector2(-1, 0),      # West
		Vector2(-0.7, -0.7), # Northwest
		Vector2(-0.7, 0.7)   # Southwest
	]
	
	var best_match = possible_directions[0]
	var best_dot = -1
	for dir in possible_directions:
		var dot = shot_direction.dot(dir)
		if dot > best_dot:
			best_dot = dot
			best_match = dir
			
	var shot_speed = 200
	var puck_velocity = best_match * shot_speed
	
	velocity = puck_velocity
	
	is_moving = true

func pick_up_puck(player):
	owner_player = player
	
func update_offset_based_on_direction(direction: Vector2):
	# Define offsets for each direction
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
	
func _on_Area2D_body_entered(body):
	print("Other body entered: ", body)
	if body is CharacterBody2D and owner_player == null:
		print("Other body is a Player")
		body.pick_up_puck(self)
	if body.is_in_group("goal"):
		print("GOAL!!!")
		global_position = Vector2(30, 0)  # Example center position
		velocity = Vector2.ZERO
		is_moving = false
