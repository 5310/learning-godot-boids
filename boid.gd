class_name Boid extends Area2D


@onready var screen_rect = get_viewport_rect()

@export_range(0, 100) var speed: float = 1.0
@export_range(0, 200) var range: int: 
	get:
		return $CollisionShape2D.shape.radius
	set(value):
		$CollisionShape2D.shape.radius
@export_range(0, 100) var radius: float = 20
@export_range(0, 1) var separation: float = 0.01
@export_range(0, 1) var alignment: float = 0.05
@export_range(0, 1) var cohesion: float = 0.005

var bearing: Vector2 = Vector2(0, 1)


func _ready() -> void:
	range = 100
	position = Vector2(randf() * screen_rect.size.x, randf() * screen_rect.size.y)
	bearing = Vector2(0, 1).rotated(randf() * TAU)
	rotation = bearing.angle()
	pass


func _physics_process(delta: float) -> void:
	
	var neighbors = get_overlapping_areas()
	var cohesion_target = neighbors.reduce(func (sum, neighbor): return sum + neighbor.position, Vector2(0, 0))/(neighbors.size() if neighbors else 1) - position
	var alignment_target = neighbors.reduce(func (sum, neighbor): return sum + neighbor.bearing, Vector2(0, 0)).normalized()
	var separation_target = Vector2()
	for neighbor in neighbors:
		var distance = neighbor.position - position
		if distance.length() < radius:
			separation_target -= distance.normalized() * (radius - distance.length())
	
	bearing = (bearing + alignment_target * alignment + cohesion_target * cohesion + separation_target * separation).normalized()
	
	rotation = bearing.angle()
	translate(bearing * speed)
	
	position.x = wrapf(position.x, screen_rect.position.x, screen_rect.end.x)
	position.y = wrapf(position.y, screen_rect.position.y, screen_rect.end.y)
	
	pass
