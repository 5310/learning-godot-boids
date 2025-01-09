class_name Boid extends Area2D


@onready var screen_rect = get_viewport_rect()

var timescale = 60
var patience: float = 1.0
var speed: float = 1.0
var range: int: 
	get:
		return $CollisionShape2D.shape.radius
	set(value):
		$CollisionShape2D.shape.radius
var radius: float = 20
var separation: float = 0.01
var alignment: float = 0.01
var cohesion: float = 0.01


func _ready() -> void:
	range = 100
	position = Vector2(randf() * screen_rect.size.x, randf() * screen_rect.size.y)
	rotation = randf() * TAU


func _process(delta: float) -> void:
		
	var neighbors = get_overlapping_areas()
	var cohesion_target = neighbors.reduce(func (sum, neighbor): return sum + neighbor.position, Vector2(0, 0))/(neighbors.size() if neighbors else 1) - position
	var alignment_target = Vector2.RIGHT.rotated(neighbors.reduce(func (sum, neighbor): return sum + neighbor.rotation, 0)/(neighbors.size() if neighbors else 1))
	var separation_target = Vector2()
	for neighbor in neighbors:
		var distance = neighbor.position - position
		if distance.length() < radius:
			separation_target -= distance.normalized() * (radius - distance.length())
	
	var bearing = Vector2.RIGHT.rotated(rotation)
	bearing = (bearing + (alignment_target * alignment + cohesion_target * cohesion + separation_target * separation) * delta * timescale).normalized()
	
	translate(bearing * speed * delta * timescale)
	rotation = bearing.angle()
	
	position.x = wrapf(position.x, screen_rect.position.x, screen_rect.end.x)
	position.y = wrapf(position.y, screen_rect.position.y, screen_rect.end.y)
