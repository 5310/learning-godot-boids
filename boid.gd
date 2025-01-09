class_name Boid extends Area2D


@onready var screen_rect = get_viewport_rect()

static var timescale = 60
static var heat = 0.0
static var speed: float = 1.0
static var radius: float = 20
static var range: float = 50
static var separation: float = 0.01
static var alignment: float = 0.01
static var cohesion: float = 0.01


func _ready() -> void:
	position = Vector2(randf() * screen_rect.size.x, randf() * screen_rect.size.y)
	rotation = randf() * TAU


func _process(delta: float) -> void:
	
	$CollisionShape2D.shape.radius = max(radius, 10)
	
	var neighbors = get_overlapping_areas()
	var cohesion_target = neighbors.reduce(func (sum, neighbor): return sum + neighbor.position, Vector2(0, 0))/(neighbors.size() if neighbors else 1) - position
	var alignment_target = Vector2.RIGHT.rotated(neighbors.reduce(func (sum, neighbor): return sum + neighbor.rotation, 0)/(neighbors.size() if neighbors else 1))
	var separation_target = Vector2()
	for neighbor in neighbors:
		var distance = neighbor.position - position
		if distance.length() < radius:
			separation_target -= distance.normalized() * (radius - distance.length())
	var jitter = randf_range(-1, +1) * TAU * delta * (1 if randf() < heat else 0)
	
	var bearing = Vector2.RIGHT.rotated(rotation)
	bearing += (alignment_target * alignment + cohesion_target * cohesion + separation_target * separation) * delta * timescale
	bearing = bearing.normalized()
	
	translate(bearing * speed * delta * timescale)
	rotation = bearing.angle()
	rotate(jitter)
	
	position.x = wrapf(position.x, screen_rect.position.x, screen_rect.end.x)
	position.y = wrapf(position.y, screen_rect.position.y, screen_rect.end.y)
