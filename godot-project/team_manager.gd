extends Node2D


const PLAYER_COUNT = 5

@export var player_scene: PackedScene

var players = []
var current_player_index = 0

func initialize_team(team_number):
	for i in range(PLAYER_COUNT):
		#var player = CharacterBody2D.new()
		var player = player_scene.instantiate()
		player.name = "Player" + str(i + 1)
		player.position = Vector2(10 * i, team_number * 5)  # Spread out players
		add_child(player)
		players.append(player)
		print("Created:", player.name, "at", player.position)

func select_player(index):
	for i in range(players.size()):
		players[i].set_controlled(i == index)
		
	# Enable camera only on the active player
	for i in range(players.size()):
		var camera = players[i].get_node("Camera2D")
		camera.enabled = (i == index)
	#deselect_current_player()
	#current_player_index = index
	#highlight_current_player()

func select_next_player():
	current_player_index = (current_player_index + 1) % players.size()
	highlight_current_player()

func deselect_current_player():
	if players.size() > 0:
		players[current_player_index].modulate = Color(1, 1, 1, 1)  # Normal color

func highlight_current_player():
	if players.size() > 0:
		players[current_player_index].modulate = Color(1, 1, 0, 1)  # Yellow highlight
