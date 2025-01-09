extends Node2D


@export_range(20, 2000) var population: float = 200
var boid_scene = preload("res://boid.tscn")

@export_range(0, 100) var speed: float = 1.0
@export_range(0, 200) var range: int = 20
@export_range(0, 100) var radius: float = 20
@export_range(0, 1) var separation: float = 0.01
@export_range(0, 1) var alignment: float = 0.05
@export_range(0, 1) var cohesion: float = 0.005


func _ready() -> void:
	for i in population: 
		var boid = boid_scene.instantiate()
		boid.speed = speed
		boid.range = range
		boid.radius = radius
		boid.separation = separation
		boid.alignment = alignment
		boid.cohesion = cohesion
		add_child(boid)
	pass


func _process(delta: float) -> void:
	pass
