extends Node2D

@onready var team1 = $Team1
#@onready var team2 = $Team2

var current_team: Node = null
var current_player: Node = null

func _ready():
	initialize_teams()
	
func initialize_teams():
	team1.initialize_team(1)
	#team2.initialize_team(2)
	switch_to_team(team1)

func switch_to_team(team):
	if current_team:
		current_team.deselect_current_player()
	current_team = team
	current_team.select_player(0)

func switch_player():
	if current_team:
		current_team.select_next_player()

func _input(event):
	if event.is_action_pressed("switch_player"):
		switch_player()
