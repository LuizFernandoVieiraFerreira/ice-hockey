extends Node2D

class_name Puck

@onready var area2d = $Area2D

var owner_player: Node2D = null # The player currently controlling the puck

var offset = Vector2(10, 0)
var speed = 300 # Base speed for passes/shots
var friction = 0.98 # Friction for when the puck is loose

func _ready():
	area2d.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _physics_process(delta):
	if owner_player:
		global_position = owner_player.global_position + offset

func pass_puck(direction: Vector2):
	owner_player = null

func shoot_puck(direction: Vector2):
	owner_player = null

func pick_up_puck(player):
	owner_player = player
	
func _on_Area2D_body_entered(body):
	print("Other body entered: ", body)
	if body is Player and owner_player == null:
		print("Other body is a Player")
		body.pick_up_puck(self)
