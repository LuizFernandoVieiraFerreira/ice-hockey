extends CharacterBody2D

class_name Player

@onready var animated_sprite = $AnimatedSprite2D

var puck: Node2D = null

var speed = 100
var last_direction = Vector2(1, 0)
var is_shooting = false

var goal_position = Vector2(255, 0)

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if is_shooting:
		return
		
	var input_vector = Vector2.ZERO

	# Get input for movement (you can customize the key mappings)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	# Move the player
	position += input_vector * speed * delta
	
	# Determine facing direction and play corresponding animation
	if input_vector != Vector2.ZERO:
		play_skate_animation(input_vector)
		last_direction = input_vector
	else:
		play_skate_animation(last_direction)
		
	# If the player is controlling the puck, update the puck's offset
	if puck:
		puck.update_offset_based_on_direction(last_direction)
		
	# Handle passing and shooting the puck
	if puck:
		if Input.is_action_just_pressed("pass"):
			puck.pass_puck(last_direction)
			puck = null
		elif Input.is_action_just_pressed("shoot"):
			var shot_direction = (goal_position - global_position).normalized()
			play_shoot_animation(shot_direction)
			puck.shoot_puck(last_direction)
			puck = null

func play_skate_animation(direction: Vector2):
	if direction.y < 0 and direction.x == 0:
		animated_sprite.play("skate_north")
	elif direction.y < 0 and direction.x > 0:
		animated_sprite.play("skate_northeast")
	elif direction.y == 0 and direction.x > 0:
		animated_sprite.play("skate_east")
	elif direction.y > 0 and direction.x > 0:
		animated_sprite.play("skate_southeast")
	elif direction.y > 0 and direction.x == 0:
		animated_sprite.play("skate_south")
	elif direction.y > 0 and direction.x < 0:
		animated_sprite.play("skate_southwest")
	elif direction.y == 0 and direction.x < 0:
		animated_sprite.play("skate_west")
	elif direction.y < 0 and direction.x < 0:
		animated_sprite.play("skate_northwest")

func play_shoot_animation(direction: Vector2):
	is_shooting = true
		
	if direction.x > 0 and abs(direction.y) < 0.5:  # Right
		animated_sprite.play("shoot_east")
	elif direction.x > 0 and direction.y < 0:  # Northeast
		animated_sprite.play("shoot_northeast")
	elif direction.x > 0 and direction.y > 0:  # Southeast
		animated_sprite.play("shoot_southeast")
	elif direction.x < 0 and abs(direction.y) < 0.5:  # Left
		animated_sprite.play("shoot_west")
	elif direction.x < 0 and direction.y < 0:  # Northwest
		animated_sprite.play("shoot_northwest")
	elif direction.x < 0 and direction.y > 0:  # Southwest
		animated_sprite.play("shoot_southwest")

func _on_animation_finished():
	if is_shooting:
		is_shooting = false

func pick_up_puck(new_puck: Node2D):
	puck = new_puck
	puck.pick_up_puck(self)
