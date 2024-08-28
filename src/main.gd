extends Node2D

class Box:
	var position: Vector2
	var used: bool

	func _init(x: float, y: float, is_used: bool):
		position = Vector2(x, y)
		used = is_used

var max_score: int = 0
var score: int = 0
var time_passed: float = 0.0
var apple_scene = preload("res://scenes/apple.tscn")
var width: int = 32
var height: int = 32
var rows: int = 20
var columns: int = 20
var boxes: Array[Box] = []
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

func spawn_apple():
	var apple = apple_scene.instantiate()
	apple.position.x = randi_range(0, columns - 1) * width
	apple.position.y = randi_range(0, rows - 1) * height
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
