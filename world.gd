extends Node2D


const boid_poopulation = 200
const boid_scene = preload("res://boid_2.tscn")

func _ready() -> void:
	$Boid2_Sys.instantiate()
