extends Node

const delta_scale = 60

static var population = 500
static var size: float = 10
static var speed: float = 2
static var impetus_bias: float = 1
static var separation_range: float = 100
static var separation_bias: float = 0.2

var hashgrid: = []
var hashgrid_: = []
var hashgrid_size = 200
var hashgrid_scale = 100

const boid_scene = preload("res://boid_2.tscn")
@onready var screen_rect: Rect2 = get_tree().get_current_scene().get_viewport_rect().grow_individual(size, size, size, size)


func _ready() -> void:
	instantiate()
	hashgrid = range(hashgrid_size).map(func (i): return [])
	hashgrid_ = range(hashgrid_size).map(func (i): return [])
	process_priority = 1000

func _process(delta: float) -> void:
	update(delta)


func boids_all():
	return get_parent().get_children().filter(func (child): return child is Boid2).map(func (_boid): return _boid as Boid2)
	
func boids_neighbors(center: Vector2):
	var neighborhood = []
	for x in range(-1, +1): for y in range(-1, +1): neighborhood.push_back(wrapv2(center + Vector2(x, y)))
	var neighbors = []
	for cell in neighborhood:
		var index = hash(Vector2i(cell / hashgrid_scale)) % hashgrid_size
		neighbors.append_array(hashgrid[index])
	return neighbors

func instantiate() -> void:
	for i in range(population): 
		var boid = boid_scene.instantiate()
		boid.position = Vector2(randf() * screen_rect.size.x, randf() * screen_rect.size.y)
		boid.rotation = randf() * TAU
		get_parent().add_child(boid)

func update(delta: float) -> void:
	for xs in hashgrid_:
		xs.clear()
	
	var boids = boids_all()
	for boid in boids:
		
		var impetus = Vector2.RIGHT.rotated(boid.rotation)
		var separation = boids_neighbors(boid.position)\
			.map(func (b): return boid.position - b.position)\
			.filter(func (d): return d.length() <= separation_range)\
			.map(func (d): return d.normalized() * (1 - d.length() / separation_range))\
			.reduce(func (acc, f): return acc + f, Vector2())
		var bearing = impetus + (separation * separation_bias) / impetus_bias * delta * delta_scale
		
		boid.rotation = bearing.angle()
		boid.position = wrapv2(boid.position + (bearing.normalized() * speed * delta * delta_scale))
		
		var hashgrid_index = hash(Vector2i(boid.position / hashgrid_scale)) % hashgrid_size
		hashgrid_[hashgrid_index].push_back(boid)
		
	var tmp = hashgrid
	hashgrid = hashgrid_
	hashgrid_ = tmp


func wrapv2(position: Vector2) -> Vector2:
	position.x = wrapf(position.x, screen_rect.position.x, screen_rect.end.x)
	position.y = wrapf(position.y, screen_rect.position.y, screen_rect.end.y)
	return position
