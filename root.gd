extends Node2D


@export_range(20, 500) var population: int = 200
var boid_scene = preload("res://boid.tscn")

@export_range(0, 1) var heat: float = 0.1
@export_range(0, 100) var speed: float = 1.0
@export_range(0, 100) var range: float = 50
@export_range(0, 100) var radius: float = 20
@export_range(0, 1) var separation: float = 0.01
@export_range(0, 1) var alignment: float = 0.01
@export_range(0, 1) var cohesion: float = 0.005


func _ready() -> void:
	for i in population: 
		var boid = boid_scene.instantiate()
		add_child(boid)

func _process(delta: float) -> void:
	Boid.heat = heat
	Boid.speed = speed
	Boid.range = range
	Boid.radius = radius
	Boid.separation = separation
	Boid.alignment = alignment
	Boid.cohesion = cohesion
