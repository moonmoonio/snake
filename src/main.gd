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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	max_score = 0
	$Player.crashed.connect(new_game)
	$Player.eat.connect(increase_score)
	for row in range(rows):
		for column in range(columns):
			boxes.push_back(Box.new(column * width, row * height, false))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > 3:
		spawn_apple()
		time_passed = 0

func spawn_apple():
	var apple = apple_scene.instantiate()
	while true:
		var index = randi_range(0, boxes.size() - 1)
		var box = boxes[index]
		if !box.used:
			apple.position = box.position
			boxes[index].used = true
			break
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
