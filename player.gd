extends Area2D

signal hit

@export var speed = 400 # (pixels/sec)
var screen_size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = falset

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = get_velocity(delta)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	process_animation(velocity)

func get_velocity(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	return velocity

func process_animation(velocity):
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true).
