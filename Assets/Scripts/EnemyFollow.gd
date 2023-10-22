extends Node2D

onready var enemy = $Enemy
onready var left = $Left
onready var right = $Right



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if (enemy.position.x < left.position.x):
		 enemy.dir = 1
	if (enemy.position.x > right.position.x):
		 enemy.dir = -1
