extends Node2D

var max_score: int = 0
var score: int = 0
var time_passed: float = 0.0
var apple_scene = preload("res://scenes/apple.tscn")
var width: int = 32
var height: int = 32
var rows: int = 20
var columns: int = 20
var boxes: Array[Vector2] = Array([], TYPE_VECTOR2, "", null)
var apple_timer: Timer
var apple_timer_seconds: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apple_timer = Timer.new()
	add_child(apple_timer)
	score = 0
	max_score = 0
	$Player.crashed.connect(new_game)
	$Player.eat.connect(increase_score)
	apple_timer.timeout.connect(spawn_apple)
	apple_timer.start(apple_timer_seconds)
	for row in range(rows):
		for column in range(columns):
			boxes.push_back(Vector2(column * width, row * height))

func spawn_apple():
	var apple = apple_scene.instantiate()
	var options = boxes.filter(func(pos): return !$Player.nodes.map(func(element): return element.position).has(pos))
	apple.position = options.pick_random()
	add_child(apple)

func new_game():
	score = 0
	update_scores()
	get_tree().call_group("apple", "queue_free")
	$Player.start()

func increase_score():
	score += 1
	if score > max_score:
		max_score = score
	update_scores()

func update_scores():
	%ScoreLabel.text = "Score: %d" % score
	%MaxScoreLabel.text = "Maximum score: %d" % max_score
