extends Node2D

enum Directions {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

signal eat
signal crashed
@export var step: int = 32
@export var rows: int = 20
@export var columns: int = 20
var max_row: int
var max_column: int
var time_passed: float = 0.0
var direction: Directions
var nodes: Array[Node2D] = Array([], TYPE_OBJECT, "Node2D", null)
var body_scene = preload("res://scenes/body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	max_row = (rows - 1) * step
	max_column = (columns - 1) * step


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > 0.2:
		time_passed = 0
		choose_direction()
		move_body()

func start():
	time_passed = 0.0
	direction = Directions.RIGHT
	get_tree().call_group("body", "queue_free")
	nodes.clear()
	increase_size(true)


func increase_size(first: bool):
	var node = body_scene.instantiate()
	if first:
		node.position = Vector2(0,0)
		node.eat.connect(increase_size.bind(false))
		node.eat.connect(_on_eat)
		node.crash.connect(_on_crashed)
	else:
		node.position = Vector2(-32,-32)
	nodes.push_back(node)
	call_deferred("add_child", node)


func move_body():
	var old_position = Vector2(nodes.front().position)
	var new_position = old_position 
	var tail = nodes.pop_back()
	match direction:
		Directions.UP:
			new_position.y -= step
		Directions.DOWN:
			new_position.y += step
		Directions.LEFT:
			new_position.x -= step
		Directions.RIGHT:
			new_position.x += step
	if new_position.x < 0:
		new_position.x = max_column
	if new_position.x > max_column:
		new_position.x = 0
	if new_position.y < 0:
		new_position.y = max_row
	if new_position.y > max_row:
		new_position.y = 0
	if nodes.size() > 0:
		nodes.front().position = new_position
		tail.position = old_position
		nodes.insert(1, tail)
	else:
		tail.position = new_position
		nodes.push_front(tail)

func choose_direction():
		if Input.is_action_pressed("ui_left") and direction != Directions.RIGHT:
			direction = Directions.LEFT
			return
		if Input.is_action_pressed("ui_right") and direction != Directions.LEFT:
			direction = Directions.RIGHT
			return
		if Input.is_action_pressed("ui_up") and direction != Directions.DOWN:
			direction = Directions.UP
			return
		if Input.is_action_pressed("ui_down") and direction != Directions.UP:
			direction = Directions.DOWN
			return

func _on_crashed():
	crashed.emit()

func _on_eat():
	eat.emit()

