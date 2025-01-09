extends Node2D


@export_range(20, 500) var population: int = 200
var boid_scene = preload("res://boid.tscn")

@export_range(0b00, 0b11, 0b1) var optimization: int = 0b00
@export_range(0, 100) var speed: float = 1
@export_range(0, 100) var range: float = 50
@export_range(0, 100) var radius: float = 20
@export_range(0, 1, 0.01, "suffix:**2") var alignment: float = 0.5
@export_range(0, 1, 0.01, "suffix:**2") var cohesion: float = 0.2
@export_range(0, 1, 0.01, "suffix:**2") var separation: float = 0.5
@export_range(0, 1, 0.01, "suffix:**2") var heat: float = 0.1
@export_range(0, 100, 0.1) var impetus: float = 20


func _ready() -> void:
	for i in population: 
		var boid = boid_scene.instantiate()
		add_child(boid)

func _process(delta: float) -> void:
	Boid.optimization = optimization
	Boid.speed = speed
	Boid.range = range
	Boid.radius = radius
	Boid.alignment = alignment ** 3
	Boid.cohesion = cohesion ** 3
	Boid.separation = separation ** 3
	Boid.heat = heat ** 3
	Boid.impetus = impetus
