class_name Boid extends Area2D


@onready var screen_rect = get_viewport_rect()

static var timescale: float = 60
static var optimization: int = 0b00
static var speed: float = 1
static var radius: float = 20
static var range: float = 50
static var alignment: float = 1
static var cohesion: float = 1
static var separation: float = 1
static var heat: float = 0
static var impetus: float = 0



func _ready() -> void:
	position = Vector2(randf() * screen_rect.size.x, randf() * screen_rect.size.y)
	rotation = randf() * TAU
	var opt = 0.25
	set_collision_layer(2 ** (randi() % 3))
	set_collision_mask(0b1111 - ((2 ** 0) - 1))


func _process(delta: float) -> void:	
	$CollisionShape2D.shape.radius = max(radius, 10)
	
	var neighbors = get_overlapping_areas()
	var alignment_target = Vector2.RIGHT.rotated(neighbors.reduce(func (sum, neighbor): return sum + neighbor.rotation, 0)/(neighbors.size() if neighbors else 1))
	var cohesion_target = neighbors.reduce(func (sum, neighbor): return sum + neighbor.position, position)/(neighbors.size()+1 if neighbors else 1) - position
	var separation_target = Vector2()
	for neighbor in neighbors:
		var distance = neighbor.position - position
		if distance.length() < radius:
			separation_target -= distance.normalized() * (radius - distance.length())

	var target = impetus * Vector2.RIGHT.rotated(rotation) + alignment_target * alignment + cohesion_target * cohesion + separation_target * separation
	var bearing = target.normalized()
	
	translate(bearing * speed * delta * timescale)
	rotation = bearing.angle()
	
	var jitter = randf_range(-1, +1) * TAU * delta * (1 if randf() < heat else 0)
	rotate(jitter)
	
	position.x = wrapf(position.x, screen_rect.position.x, screen_rect.end.x)
	position.y = wrapf(position.y, screen_rect.position.y, screen_rect.end.y)
