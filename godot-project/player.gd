extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var speed = 100
var last_direction = Vector2(1, 0)

func _physics_process(delta):
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
